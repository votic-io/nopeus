json.customer do
	json.(@customer, :id, :application_id, :first_name, :last_name, :company, :email_address, :phone_number, :mobile, :created_at, :updated_at, :password_digest, :properties)
	json.errors @errors
end