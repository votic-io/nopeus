json.user do
	json.(@user, :id, :application_id, :first_name, :last_name, :email_address, :created_at, :updated_at, :password_digest, :application)
end