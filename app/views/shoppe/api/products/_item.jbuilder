json.(p, :id, :application_id, :parent_id, :sku, :name, :full_name, :permalink, :full_permalink, :description, :short_description, :active, :weight, :price, :cost_price, :tax_rate_id, :created_at, :updated_at, :featured, :in_the_box, :stock_control, :default, :default_image)
json.display_price number_to_currency p.price
json.option_values p.option_values do |ov|
	json.(ov, :id, :application_id, :option_type, :value)
end
json.images p.attachments do |i|
	json.(i, :application_id, :created_at, :file_name, :file_size, :file_type, :id, :parent_id, :parent_type, :role, :token, :updated_at)
	json.(i.file, :url, :thumb)
end
json.product_categories p.product_categories do |pc|
		json.partial! 'shoppe/api/product_categories/item', p: pc
end