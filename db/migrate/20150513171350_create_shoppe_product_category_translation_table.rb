class CreateShoppeProductCategoryTranslationTable < ActiveRecord::Migration
  def up
    Shoppe::ProductCategory.create_translation_table! name: :string, permalink: :string, description: :text

    Shoppe::ProductCategory.unscoped.all.each do |pc|
      l = pc.translations.new
      l.locale = 'en'
      l.name = pc.name
      l.permalink = pc.permalink
      l.description = pc.description
      l.save!
    end
  end

  def down
    Shoppe::ProductCategory.drop_translation_table!
  end
end