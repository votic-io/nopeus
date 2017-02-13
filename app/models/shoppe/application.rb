module Shoppe
  class Application < ActiveRecord::Base
    # Set the table name
    self.table_name = 'shoppe_application'

    validates :token, presence: true

    # Set some defaults
    before_validation { self.token = SecureRandom.uuid  if token.blank? }
    
    scope :current, -> { where(token: Thread.current[:app_token]) }

    def self.ransackable_attributes(_auth_object = nil)
      %w(id name token) + _ransackers.keys
    end
    
  end
end
