class CreateShoppePromotions < ActiveRecord::Migration
  def change
    create_table :shoppe_promotions do |t|
      t.integer  :application_id, null: false
      t.string :type, null: false
      t.string :name, null: false
      
      t.integer :requirement_day_of_week
      t.integer :requirement_category_id

      t.boolean :benefit_double
      t.decimal :benefit_factor
      t.decimal :benefit_amount

      t.boolean :active, default: true
    end
  end
end