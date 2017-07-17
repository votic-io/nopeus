json.cache! ['item', p.id, p.updated_at], expires_in: 10.minutes do
	json.(p, :id, :application_id, :parent_id, :sku, :name, :full_name, :permalink, :full_permalink, :description, :short_description, :active, :weight, :price, :cost_price, :tax_rate_id, :created_at, :updated_at, :featured, :in_the_box, :stock_control, :default, :default_image, :final_price)
	json.display_price number_to_currency p.final_price
	json.option_values p.option_values do |ov|
		json.(ov, :id, :application_id, :option_type, :value)
	end
	json.images p.attachments do |i|
		json.(i, :application_id, :created_at, :file_name, :file_size, :file_type, :id, :parent_id, :parent_type, :role, :token, :updated_at)
		json.(i.file, :url)
		json.file i.file.as_json[:file]
	end
	json.product_categories p.product_categories do |pc|
		json.cache! ['item', pc], expires_in: 10.minutes do
			json.partial! 'shoppe/api/product_categories/item', p: pc
		end
	end
	json.discounts p.active_discounts
	json.errors @errors
end