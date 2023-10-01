class RecipeSearchService
  # @param keyphrase [String] comma-separated list of ingredients
  def initialize(keyphrase)
    @ingredients = keyphrase.split(',').map(&:strip).map(&:downcase)
  end

  # Searches for recipes that include all of the provided ingredients.
  #
  # @return [ActiveRecord::Relation] the matching recipes (or none)
  def call
    return Recipe.none if @ingredients.blank?

    # Get IDs of recipes that have the ALL the specified ingredients
    # (but we don't know if they have more ingredients than that)
    matching_recipes = Recipe.joins(:ingredients).
                             where(ingredients: { name: @ingredients }).
                             group('recipes.id').
                             having('COUNT(DISTINCT ingredients.id) = ?', @ingredients.count).
                             pluck(:id)

    # From those IDs, filter further to ensure they have ONLY the specified ingredients
    Recipe.joins(:ingredients).
          where(id: matching_recipes).
          group('recipes.id').
          having('COUNT(DISTINCT ingredients.id) = ?', @ingredients.count)
  end
end
