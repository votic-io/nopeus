class RenamePhoneToShoppeCustomers < ActiveRecord::Migration
  def change
    rename_column :shoppe_customers, :phone, :phone_number
    rename_column :shoppe_customers, :email, :email_address
  end
end
