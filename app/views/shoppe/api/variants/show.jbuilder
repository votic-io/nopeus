json.variant do
	json.partial! 'shoppe/api/products/item', p: @variant
	json.variants @variant.variants do |v|
		json.partial! 'shoppe/api/products/item', p: v
	end
end