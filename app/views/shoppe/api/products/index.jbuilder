json.products @products do |pp|
	json.partial! 'item', p: pp
	json.variants pp.variants do |v|
		json.partial! 'shoppe/api/products/tiny', p: v
	end
end