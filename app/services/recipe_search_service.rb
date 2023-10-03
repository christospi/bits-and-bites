class RecipeSearchService
  # @param keyphrase [String] comma-separated list of ingredients
  def initialize(keyphrase)
    @ingredients = parse_ingredients(keyphrase)
  end

  # Searches for recipes that can be made with the specified ingredients.
  # A recipe is considered a match if:
  # * it has ALL the specified ingredients but no more
  # * it has LESS than the specified ingredients
  #
  # @return [ActiveRecord::Relation] the matching recipes (or none)
  def call
    return Recipe.none if @ingredients.blank?

    # Get the recipes that have ingredients other than the specified ones.
    # Notes:
    # (1) We use RecipesIngredient directly to avoid an extra query, since
    # we only need the recipe_id and the ingredient name.
    # (2) Also, we do not materialize the ActiveRecord objects to let the DB do
    # the heavy lifting with nested query.
    not_matching_recipes = RecipesIngredient.joins(:ingredient).
      where.not(ingredients: { name: @ingredients }).
      distinct.select('recipe_id')

    # The recipes that all their ingredients are included in the specified ones.
    Recipe.where.not(id: not_matching_recipes)
  end

  private

  # Converts a comma-separated list of ingredients into an array of unique
  # ingredients.
  #
  # @param keyphrase [String] comma-separated list of ingredients
  # @return [Array<String>] the unique ingredients
  def parse_ingredients(keyphrase)
    keyphrase.split(',').map(&:strip).map(&:downcase).compact_blank.uniq
  end
end
