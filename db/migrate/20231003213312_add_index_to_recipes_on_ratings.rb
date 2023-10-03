class AddIndexToRecipesOnRatings < ActiveRecord::Migration[7.0]
  def change
    add_index :recipes, :ratings
  end
end
