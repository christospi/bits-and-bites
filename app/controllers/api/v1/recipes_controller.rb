class Api::V1::RecipesController < ApplicationController
  PAGE_SIZE = 12

  before_action :fetch_recipe, only: [:show]

  def index
    recipes = Recipe.includes(:recipe_ingredients, :ingredients).
      page(params[:page]).per(PAGE_SIZE)

    render json: {
      recipes: ActiveModel::Serializer::CollectionSerializer.new(
        recipes,
        each_serializer: RecipeSerializer
      ),
      meta: {
        total_pages: recipes.total_pages,
        current_page: recipes.current_page
      }
    }
  end

  def show
    render json: @recipe, serializer: RecipeSerializer
  end

  private

  def fetch_recipe
    @recipe = Recipe.find(params[:id])
  end
end
