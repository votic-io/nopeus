json.customer do
	json.(@customer, :id, :application_id, :first_name, :last_name, :company, :email_address, :phone_number, :mobile, :created_at, :updated_at, :password_digest, :properties)
	json.billing_address do
		json.partial! 'shoppe/api/addresses/item', a: @customer.addresses.billing.last
	end
	json.delivery_address do
		json.partial! 'shoppe/api/addresses/item', a: @customer.addresses.delivery.last
	end
	json.errors @errors
end