json.(p, :id, :application_id, :name, :permalink, :description, :created_at, :updated_at, :parent_id, :depth, :ancestral_permalink, :permalink_includes_ancestors)
json.children p.children do |c|
	json.partial! 'item', p: c
end