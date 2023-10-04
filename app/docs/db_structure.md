classDiagram
direction BT
class ApplicationRecord
class Ingredient {
   Ingredient ingredients
   RecipesIngredient recipes_ingredients
   string name
   datetime created_at
   integer id
   datetime updated_at
}
class Recipe {
   Ingredient ingredients
   RecipesIngredient recipes_ingredients
   string author
   string category
   integer cook_time_in_minutes
   string cuisine
   text image_url
   integer prep_time_in_minutes
   decimal ratings
   string title
   datetime created_at
   integer id
   datetime updated_at
}
class RecipesIngredient {
   RecipesIngredient recipes_ingredients
   string quantity
   datetime created_at
   integer id
   bigint ingredient_id
   bigint recipe_id
   datetime updated_at
}

ApplicationRecord  --|>  Ingredient 
Ingredient "1" --* "0..*" RecipesIngredient 
ApplicationRecord  --|>  Recipe 
Ingredient "0..*" -- "0..*" Recipe 
Recipe "1" --* "0..*" RecipesIngredient 
ApplicationRecord  --|>  RecipesIngredient 
