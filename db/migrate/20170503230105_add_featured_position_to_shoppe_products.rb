class AddFeaturedPositionToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :featured_position, :integer
  end
end
