json.product do
	json.(@product, :id, :application_id, :parent_id, :name, :permalink, :description, :short_description, :active, :weight, :price, :cost_price, :tax_rate_id, :created_at, :updated_at, :featured, :in_the_box, :stock_control, :default, :default_image, :variants)
	json.display_price number_to_currency @product[:price]
end