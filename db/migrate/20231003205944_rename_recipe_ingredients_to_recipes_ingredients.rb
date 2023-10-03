class RenameRecipeIngredientsToRecipesIngredients < ActiveRecord::Migration[7.0]
  def change
    rename_table :recipe_ingredients, :recipes_ingredients
  end
end
