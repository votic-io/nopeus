json.count @query.count
json.customers @customers do |c|
	json.partial! 'item', customer: c
end
