json.(p, :id, :application_id, :parent_id, :name, :full_name, :permalink, :full_permalink, :description, :short_description, :active, :weight, :price, :cost_price, :tax_rate_id, :created_at, :updated_at, :featured, :in_the_box, :stock_control, :default, :default_image)
json.display_price number_to_currency p.price
json.product_categories p.product_categories do |pc|
		json.partial! 'shoppe/api/product_categories/item', p: pc
end