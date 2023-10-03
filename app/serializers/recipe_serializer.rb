class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :cook_time_in_minutes, :prep_time_in_minutes,
             :ratings, :category, :cuisine, :author, :image_url, :ingredients

  def image_url
    object.image_url || ActionController::Base.helpers.asset_path('recipe/image.webp')
  end

  def ingredients
    object.recipes_ingredients.map do |recipe_ingredient|
      {
        id: recipe_ingredient.ingredient.id,
        name: recipe_ingredient.ingredient.name,
        quantity: recipe_ingredient.quantity
      }
    end
  end
end
