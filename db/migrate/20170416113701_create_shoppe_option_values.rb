class CreateShoppeOptionValues < ActiveRecord::Migration
  def up
    create_table :shoppe_option_values do |t|
      t.integer  :application_id, null: false
      t.string :type, null: false
      t.string :value, null: false
      t.string :content
      t.timestamps
    end
    
    add_column :shoppe_products, :option_value_id, :integer
  end

  def down
    drop_table :shoppe_option_values
    remove_column :shoppe_products, :option_value_id
  end
end