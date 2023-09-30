class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time_in_minutes, null: false
      t.integer :prep_time_in_minutes, null: false
      t.decimal :ratings, default: 0, precision: 4, scale: 2
      t.string :cuisine
      t.string :category
      t.string :author
      t.text :image_url

      t.timestamps
    end
  end
end
