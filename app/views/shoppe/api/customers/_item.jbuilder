json.(customer, :id, :application_id, :first_name, :last_name, :full_name, :company, :email_address, :phone_number, :mobile, :created_at, :updated_at, :password_digest, :properties)
json.billing_address do
	json.partial!('shoppe/api/addresses/item', a: customer.addresses.billing.last) unless customer.addresses.delivery.last.nil?
end
json.delivery_address do
	json.partial!('shoppe/api/addresses/item', a: customer.addresses.delivery.last) unless customer.addresses.delivery.last.nil?

end
json.errors @errors