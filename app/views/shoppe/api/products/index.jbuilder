json.cache! ['index', @products, Thread.current[:cache_key]], expires_in: 10.minutes do
	json.products @products do |p|
		json.cache! ['item', p, Thread.current[:cache_key]], expires_in: 10.minutes do
			json.partial! 'item', p: p
		end
		json.variants p.variants do |v|
			json.cache! ['tiny', v, Thread.current[:cache_key]], expires_in: 10.minutes do
				json.partial! 'shoppe/api/products/tiny', p: v
			end
		end
	end
end