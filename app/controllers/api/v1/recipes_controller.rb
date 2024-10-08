class Api::V1::RecipesController < ApplicationController
  PAGE_SIZE = 12

  before_action :fetch_recipe, only: [:show]

  def index
    if valid_params[:keyphrase].present?
      @recipes = ::RecipeSearchService.new(valid_params[:keyphrase]).call
    else
      @recipes = Recipe.all.order_by_ratings
    end

    @recipes = @recipes.includes_ingredients.
      page(valid_params[:page]).per(PAGE_SIZE)

    render json: {
      recipes: ActiveModel::Serializer::CollectionSerializer.new(
        @recipes,
        each_serializer: RecipeSerializer
      ),
      meta: { total_pages: @recipes.total_pages }
    }
  end

  def show
    render json: @recipe, serializer: RecipeSerializer
  end

  private

  def fetch_recipe
    @recipe = Recipe.find(valid_params[:id])
  end

  def valid_params
    params.permit(:id, :page, :keyphrase)
  end
end
