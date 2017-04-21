class CreateShoppeProductOptionValues < ActiveRecord::Migration
  def change
    create_table :shoppe_product_option_values do |t|
      t.integer  :application_id, null: false
      t.integer :product_id, null: false
      t.integer :option_value_id, null: false
    end
    remove_column :shoppe_products, :option_value_id
  end
end