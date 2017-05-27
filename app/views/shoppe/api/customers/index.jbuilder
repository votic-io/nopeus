json.customers @customers do |c|
	json.partial! 'item', customer: c
end
