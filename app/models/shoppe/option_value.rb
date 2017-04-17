module Shoppe
  class OptionValue < ActiveRecord::Base
    include ApplicationModel
    self.table_name = 'shoppe_option_values'

    # The associated product
    #
    # @return [Shoppe::Product]
    belongs_to :product, class_name: 'Shoppe::Product'

    validates :type, presence: true
    validates :name, presence: true, uniqueness: {scope: [:application_id, :type]}

  end
end