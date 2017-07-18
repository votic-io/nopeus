json.product do
	json.partial! 'item', p: @product
	json.variants @product.variants do |v|
		json.partial! 'shoppe/api/products/item', p: v
	end
end
json.debug @debug