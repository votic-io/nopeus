class CreateShoppeProductCategoryTranslationTable < ActiveRecord::Migration
  def up
    #Shoppe::ProductCategory.create_translation_table! name: :string, permalink: :string, description: :text

    Shoppe::ProductCategory.unscoped.all.each do |pc|
      
    end
  end

  def down
    Shoppe::ProductCategory.drop_translation_table!
  end
end