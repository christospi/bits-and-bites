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
        quantity: recipe_ingredient.quantity,
        matched: matched_ingredient_ids.include?(recipe_ingredient.ingredient.id)
      }
    end.sort_by { |ingredient| ingredient[:matched] ? 0 : 1 }
  end

  private

  def matched_ingredient_ids
    object.try(:matched_ingredient_ids) || []
  end
end
