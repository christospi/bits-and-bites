namespace :recipes do
  desc 'Import recipes from a JSON file'
  task :import, [:file_path] => :environment do |_, args|
    file_path = args[:file_path]

    unless File.exist?(file_path) && File.extname(file_path) == '.json'
      puts 'Invalid input file! Please provide a valid JSON file.'
      exit
    end

    begin
      # Parse the JSON file
      file_content = File.read(file_path)
      recipes_data = JSON.parse(file_content)
    rescue JSON::ParserError => e
      puts "Error parsing JSON: #{e.message}"
      exit
    end

    successful_imports = 0

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
        parse_ingredients(recipe_data['ingredients']).each do |quantity, ingredient_name|
          # Downcase to avoid duplicates
          ingredient_name = ingredient_name.downcase

          # Find or create the Ingredient record
          ingredient = Ingredient.find_or_create_by!(name: ingredient_name)

          RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: quantity)
        end

        successful_imports += 1
      rescue ActiveRecord::RecordInvalid => e
        puts "Error creating recipe: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end

    puts "Successfully imported #{successful_imports}/#{recipes_data.count} recipes!"
  end

  def parse_ingredients(ingredients_desc)
    parsed_ingredients = []

    # Best effort regex, based on a few examples (and some chef guessing)
    pattern = %r{
      ^((?:[\d\s\./\-\⅓\⅔\½\¼\¾⅛]+)?(?:cups?|teaspoons?|tablespoons?|tbsps?|tsps?|pints?|ounces?|oz|fluid\ ounces?|
      fl\ oz|grams?|g|pinch|kilograms?|kg|lbs?|pounds?|packages?|pkgs?|cans?|bottles?|\(.*?\))?)(?:\s*)
      (.+)$
    }x

    ingredients_desc.each do |ingredient|
      match = ingredient.strip.match(pattern)
      if match
        parsed_ingredients << [
          match[1].strip,
          match[2].strip
        ]
      else
        parsed_ingredients << [
          nil,
          ingredient.strip
        ]
      end
    end

    parsed_ingredients
  end
end
