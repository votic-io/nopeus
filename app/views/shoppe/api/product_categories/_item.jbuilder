json.(p, :id, :application_id, :name, :permalink, :description, :created_at, :updated_at, :parent_id, :depth, :ancestral_permalink, :combined_permalink, :root_name)
json.ancestors p.ancestors do |a|
	json.partial! 'shoppe/api/product_categories/tiny', p: a
end
json.children p.children do |c|
	json.partial! 'shoppe/api/product_categories/item', p: c
end