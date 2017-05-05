json.cache! ['index', @products], expires_in: 10.minutes do
	json.products @products do |p|
		json.cache! ['item', p], expires_in: 10.minutes do
			json.partial! 'item', p: p
		end
	end
end