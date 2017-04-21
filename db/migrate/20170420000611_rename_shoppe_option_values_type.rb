class RenameShoppeOptionValuesType < ActiveRecord::Migration
  def up
    rename_column :shoppe_option_values, :type, :option_type
  end

  def down
    rename_column :shoppe_option_values, :option_type, :type
  end
end