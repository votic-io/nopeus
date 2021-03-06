json.cache! ['tiny', p] do
	json.(p, :id, :application_id, :parent_id, :name, :full_name, :permalink, :full_permalink, :description, :short_description, :active, :weight, :price, :cost_price, :tax_rate_id, :created_at, :updated_at, :featured, :in_the_box, :stock_control, :default, :default_image, :final_price)
	json.display_price number_to_currency p.final_price
end
json.cache! ['tiny-discounts', p], expires_in: 1.hour do
	json.discounts p.active_discounts
end
