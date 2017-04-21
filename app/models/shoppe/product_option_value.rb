module Shoppe
  class ProductOptionValue < ActiveRecord::Base
  	include ApplicationModel
    self.table_name = 'shoppe_product_option_values'

    # Links back
    belongs_to :product, class_name: 'Shoppe::Product'
    belongs_to :option_value, class_name: 'Shoppe::OptionValue'

    # Validations
    validates_presence_of :product, :option_value
  end
end
