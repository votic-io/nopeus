json.product_categories @product_categories do |p|
	json.partial! 'shoppe/api/product_categories/item', p: p
end