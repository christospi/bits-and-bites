class Api::V1::RecipesController < ApplicationController
  before_action :fetch_recipe, only: [:show]

  def index
    recipes = Recipe.all.order(:id)

    render json: recipes
  end

  def show
    render json: @recipe
  end

  private

  def fetch_recipe
    @recipe = Recipe.find(params[:id])
  end
end
