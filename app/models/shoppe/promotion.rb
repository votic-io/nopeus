module Shoppe
  class Promotion < ActiveRecord::Base
    include ApplicationModel

    # An array of all the available types for an address
    TYPES = %w(item order).freeze

    # Set the table name
    self.table_name = 'shoppe_promotions'

    # Validations
    validates :item, presence: true, inclusion: { in: TYPES }
    validates :name, presence: true

    scope :active, -> { where(active: true) }

    def requirements
      return {day_of_week: self.requirement_day_of_week, category_id: self.requirement_category_id}
    end

    def benefits
      return {double: self.benefit_double, factor: self.factor, amount: self.benefit_amount}
    end
  end
end
