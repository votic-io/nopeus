json.cache! ['index', @products], expires_in: 60.minutes do
	json.products @products do |p|
		json.cache! ['item', p], expires_in: 60.minutes do
			json.partial! 'item', p: p
		end
		json.variants p.variants do |v|
			json.cache! ['tiny', v], expires_in: 60.minutes do
				json.partial! 'shoppe/api/products/tiny', p: v
			end
		end
	end
end