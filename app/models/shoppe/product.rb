require 'roo'

module Shoppe
  class Product < ActiveRecord::Base
    include ApplicationModel
    self.table_name = 'shoppe_products'

    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'

    # Attachments for this product
    has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

    # The product's categorizations
    #
    # @return [Shoppe::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shoppe::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shoppe::ProductCategory]
    has_many :product_categories, class_name: 'Shoppe::ProductCategory', through: :product_categorizations

    # The product's tax rate
    #
    # @return [Shoppe::TaxRate]
    belongs_to :tax_rate, class_name: 'Shoppe::TaxRate'

    # Ordered items which are associated with this product
    has_many :order_items, dependent: :restrict_with_exception, class_name: 'Shoppe::OrderItem', as: :ordered_item

    # Orders which have ordered this product
    has_many :orders, through: :order_items, class_name: 'Shoppe::Order'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, dependent: :destroy, class_name: 'Shoppe::StockLevelAdjustment', as: :item

    # Validations
    with_options if: proc { |p| p.parent.nil? } do |product|
      product.validate :has_at_least_one_product_category
      product.validates :description, presence: true
      product.validates :short_description, presence: true
    end
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: {scope: :application_id}, permalink: true
    validates :sku, presence: true
    validates :weight, numericality: true
    validates :price, numericality: true
    validates :cost_price, numericality: true, allow_blank: true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

    # All active products
    scope :active, -> { where(active: true) }

    # All featured products
    scope :featured, -> { where(featured: true) }

    # Localisations
    translates :name, :permalink, :description, :short_description
    scope :ordered, -> { includes(:translations).order(:name) }

    def attachments=(attrs)
      if attrs['default_image'].present? && attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
      if attrs['data_sheet'].present? && attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end

      if attrs['extra'].present? && attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
    end

    # Return the name of the product
    #
    # @return [String]
    def full_name
      parent ? "#{parent.name} (#{name})" : name
    end

    def full_permalink
      parent ? "#{parent.permalink}/(#{permalink})" : permalink
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless active?
      return false if has_variants?
      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    def price
      # self.default_variant ? self.default_variant.price : read_attribute(:price)
      default_variant ? default_variant.price : read_attribute(:price)
    end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      default_variant ? default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      stock_level_adjustments.sum(:adjustment)
    end

    # Return the first product category
    #
    # @return [Shoppe::ProductCategory]
    def product_category
      product_categories.first
    rescue
      nil
    end

    # Return attachment for the default_image role
    #
    # @return [String]
    def default_image
      attachments.for('default_image')
    end

    # Set attachment for the default_image role
    def default_image_file=(file)
      attachments.build(file: file, role: 'default_image')
    end

    # Return attachment for the data_sheet role
    #
    # @return [String]
    def data_sheet
      attachments.for('data_sheet')
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
      where(id: product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shoppe:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        puts row
        # Don't import products where the name is blank
        next if row['name'].nil?
        if product = where(name: row['name']).take
          # Dont import products with the same name but update quantities
          if row['qty'].nil?
            product.stock_control = false
          else
            qty = row['qty'].to_i
            if qty > 0
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          end
        else
          product = new
          product.name = row['name']
          product.sku = row['sku']
          product.description = row['description'].nil? ? '' : row['description']
          product.short_description = row['short_description'].nil? ? '' : row['short_description']
          product.weight = row['weight'].nil? ? 0 : row['weight']
          product.price = row['price'].nil? ? 0 : row['price']
          product.permalink = row['permalink']

          product.product_categories << begin
            puts row['category_path']
            arr = row['category_path'].split('/')
            puts arr
            if arr[0] != 'Categories'
              arr.insert(0, 'Categories')
            end
            parent = nil
            c = nil
            arr.each do |name|
              if parent.nil?
                parent = Shoppe::ProductCategory.find_or_initialize_by(name: name)  
                c = parent
              else
                c = parent.children.where(name: name).first
                if c.nil?
                  c = Shoppe::ProductCategory.new(name: name)    
                  c.parent = parent
                  c.save
                  c.save
                end
                parent = c
              end
            end
            c
          end

          product.featured = !row['featured'].nil?

          if row['qty'].nil?
            product.stock_control = false
          else
            qty = row['qty'].to_i
            if qty > 0
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          end

          product.save!

          first = true
          unless row['option_values_1'].nil?
            row['option_values_1'].split('-').each do |value1|
              value1 = value1.strip
              op1 = Shoppe::OptionValue.where(option_type: row['option_type_1'].strip, value: value1).first_or_create
              
              variant_name = "#{row['sku']}_#{value1}"
              unless row['option_values_2'].nil?
                row['option_values_2'].split('-').each do |value2|
                  value2 = value2.strip
                  op2 = Shoppe::OptionValue.where(option_type: row['option_type_2'].strip, value: value2).first_or_create
                  variant_name = "#{row['sku']}_#{value1}_#{value2}"
                  variant = product.variants.create(name: variant_name, sku: "#{row['sku']}_#{variant_name}", price: product.price, weight: product.weight, default: first)
                  variant.option_values << op1
                  variant.option_values << op2
                  variant.stock_control = product.stock_control
                  variant.save
                end
              else
                variant = product.variants.create(name: variant_name, sku: "#{row['sku']}_#{variant_name}", price: product.price, weight: product.weight, default: first)
                variant.option_values << op1
                variant.stock_control = product.stock_control
                variant.save
              end
              first = false
            end
            product.import_image
            product.save!
          end
        end
      end
    end

    def import_image
      require 'aws-sdk'

      ak = ENV['AWS_AK']
      sk = ENV['AWS_SK']
      bk = ENV['AWS_BUCKET']

      Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ak, sk),
      })

      s3 = Aws::S3::Resource.new(region:'us-east-1')

      bucket = s3.bucket(bk)
      obj = bucket.object("#{Thread.current[:application][:name]}/upload/#{self.sku}.jpg")

      if obj.exists?
        image = open(obj.public_url)
        self.default_image_file = image

        self.save
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else fail I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    def active_discounts
        individual_promotions = Shoppe::Promotion.active

        time = Time.now
        if self.received_at.present?
          time = self.received_at
        end
        
        individual_promotions = individual_promotions.select{|e| e.requirements[:day_of_week] == time.in_time_zone('Buenos Aires').wday}

        result = []
        p = self
        promos = individual_promotions.select{|e| p.product_category_ids.index(e.requirements[:category_id]).present?}
        if promos.blank? && p.parent.present?
          p = p.parent
          promos = individual_promotions.select{|e| p.product_category_ids.index(e.requirements[:category_id]).present?}
        end

        promos.each do |promo|
            applied_benefit = nil
            if promo.benefits[:double].present?
                applied_benefit = {title: "#{promo[:name]} - Duplicado - #{p.name}", amount: 0}
            elsif promo.benefits[:factor].present?
                applied_benefit = {title: "#{promo[:name]} - #{p.name}", amount: -(p.price * promo.benefits[:factor])}
            elsif promo.benefits[:amount].present?
                applied_benefit = {title: "#{promo[:name]} - #{p.name}", amount: -(promo.benefits[:amount])}
            end
            result << {product_id: p.id, promo: promo, applied_benefit: applied_benefit}
        end

        return result
    end

    def children_discounts
      if self.children.present?
        self.children.collect{|e| e.active_discounts}
      else
        return []
      end
    end

    def final_price
      result = self.price

      if self.active_discounts.length > 0
        discount = self.active_discounts.first
        result += discount[:applied_benefit][:amount]
      end

      return result
    end

    private

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if product_categories.blank?
    end
  end
end
