namespace :recipes do
  desc 'Import recipes from a JSON file'
  task :import, [:file_path] => :environment do |_, args|
    file_path = args[:file_path]

    unless File.exist?(file_path) && File.extname(file_path) == '.json'
      puts 'Invalid input file, please provide a valid JSON file.'
      exit
    end

    import_recipes(file_path)
  end

  desc 'Import the whole recipes dataset'
  task import_all: :environment do
    import_recipes(Rails.root.join('db/dataset/recipes-en.json'))
  end

  desc 'Import a small subset of the recipes dataset'
  task import_small: :environment do
    import_recipes(Rails.root.join('db/dataset/recipes-en-small.json'))
  end

  private

  def import_recipes(file_path)
    begin
      # Parse the JSON file
      file_content = File.read(file_path)
      recipes_data = JSON.parse(file_content)
    rescue JSON::ParserError => e
      puts "Error parsing JSON: #{e.message}"
      exit
    end

    successful_imports = 0
    pb = ProgressBar.create(
      title: 'Importing recipes',
      total: recipes_data.count,
      format: '%t: |%B| %p%% (%c/%C) %e'
    )

    # Process each recipe from the parsed data
    recipes_data.each do |recipe_data|
      Recipe.transaction do
        # Create a new Recipe record
        recipe = Recipe.create!(
          title: recipe_data['title'],
          cook_time_in_minutes: recipe_data['cook_time'],
          prep_time_in_minutes: recipe_data['prep_time'],
          ratings: recipe_data['ratings'],
          cuisine: recipe_data['cuisine'],
          category: recipe_data['category'],
          author: recipe_data['author'],
          image_url: recipe_data['image']
        )

        # Process each ingredient of the current recipe
        recipe_data['ingredients'].each do |ingredient|
          quantity, ingredient_name = parsed_ingredients(ingredient)

          # Downcase to avoid duplicates
          ingredient_name = ingredient_name.downcase

          # Find or create the Ingredient record
          ingredient = Ingredient.find_or_create_by!(name: ingredient_name)

          RecipesIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: quantity)
        end

        successful_imports += 1
      rescue ActiveRecord::RecordInvalid => e
        puts "Error creating recipe: #{e.message}"
        raise ActiveRecord::Rollback
      ensure
        pb.increment
      end
    end

    pb.finish
    puts "Successfully imported #{successful_imports}/#{recipes_data.count} recipes!"
  end

  # Uses a regex to parse an ingredient description into its name and quantity.
  # The regex is based on a few examples (and some chef guessing).
  #
  # @param ingredient_desc [String] the original ingredient description
  # @return [Array<String>] ingredient name, quantity (or nil if not found)
  def parsed_ingredients(ingredient_desc)
    @parsed_ingredients ||= {}

    return @parsed_ingredients[ingredient_desc] if @parsed_ingredients.key?(ingredient_desc)

    # Best effort regex, based on a few examples (and some chef guessing)
    pattern = %r{
      ^((?:[\d\s\./\-\⅓\⅔\½\¼\¾⅛]+)?(?:cups?|teaspoons?|tablespoons?|tbsps?|tsps?|pints?|ounces?|oz|fluid\ ounces?|
      fl\ oz|grams?|g|pinch|kilograms?|kg|lbs?|pounds?|packages?|pkgs?|cans?|bottles?|\(.*?\))?)(?:\s*)
      (.+)$
    }x

    match = ingredient_desc.strip.match(pattern)

    if match
      @parsed_ingredients[ingredient_desc] = [
        match[1].strip,
        match[2].strip
      ]
    else
      @parsed_ingredients[ingredient_desc] = [
        nil,
        ingredient_desc.strip
      ]
    end
  end
end
