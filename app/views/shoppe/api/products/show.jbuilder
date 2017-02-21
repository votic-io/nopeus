json.product do
	json.partial! 'item', p: @product
	json.variants @product.variants do |v|
		json.partial! 'item', p: v
	end
end