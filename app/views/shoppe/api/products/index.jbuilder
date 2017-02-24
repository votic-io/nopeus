json.products @products do |p|
	json.partial! 'item', p: p
	json.variants p.variants do |v|
		json.partial! 'shoppe/api/products/item', p: v
	end
end