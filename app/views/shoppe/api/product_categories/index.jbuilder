json.product_categories @product_categories do |p|
	json.partial! 'item', p: p
end