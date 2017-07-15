module Shoppe
	module ApplicationModel
		extend ActiveSupport::Concern

		included do
			belongs_to :application, class_name: 'Shoppe::Application'

			default_scope lambda {
				where(application_id: Thread.current[:application].id)
			}	
			validates :application_id, presence: true

			before_validation { 
		    	self.application_id =  Thread.current[:application].id 
		    }
		end
	end
end