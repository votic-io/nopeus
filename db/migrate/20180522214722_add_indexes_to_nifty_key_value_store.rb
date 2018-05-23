class AddIndexesToNiftyKeyValueStore < ActiveRecord::Migration
  def change
    add_index :nifty_key_value_store, [:parent_type, :group, :parent_id, :name], name: 'index_nifty_key_value_store_group'
  end
end