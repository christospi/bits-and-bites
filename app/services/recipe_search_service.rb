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

    # TODO: We should cache most-searched ingredients, once we store the
    #   searches somewhere.
    # TODO: We should handle common typos, stems, synonyms, etc... someday :)
    matched_ingredient_ids = @ingredients.flat_map do |ingredient_name|
      Ingredient.search_by_name(ingredient_name).pluck(:id)
    end.uniq

    # Match-score is the ratio of matched ingredients to the total ingredients of the recipe
    # TODO: Optimize by caching the total ingredients count in the recipes table
    match_score_sql = Arel.sql(
      'COUNT(DISTINCT recipes_ingredients.ingredient_id) * 1.0 /
      (SELECT COUNT(*) FROM recipes_ingredients ri WHERE ri.recipe_id = recipes.id)'
    )

    # Find recipes that include the matched ingredients, and order them by:
    # * match-score (the higher the better)
    # * number of recipe ingredients (the lower the better)
    Recipe.joins(:recipes_ingredients).
      where(recipes_ingredients: { ingredient_id: matched_ingredient_ids }).
      group('recipes.id').
      select('recipes.*', 'ARRAY_AGG(recipes_ingredients.ingredient_id) AS matched_ingredient_ids', match_score_sql.as('match_score')).
      order(Arel.sql('match_score DESC, COUNT(DISTINCT recipes_ingredients.ingredient_id) ASC, recipes.id ASC'))
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
