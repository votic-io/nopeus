module Shoppe
  class OptionValue < ActiveRecord::Base
    include ApplicationModel
    self.table_name = 'shoppe_option_values'

    has_many :product_option_values, class_name: 'Shoppe::ProductOptionValue', inverse_of: :option_value
    # The associated product
    #
    # @return [Shoppe::Product]
    has_many :products, class_name: 'Shoppe::Product', through: :product_option_values

    validates :option_type, presence: true
    validates :value, presence: true, uniqueness: {scope: [:application_id, :option_type]}

  end
end