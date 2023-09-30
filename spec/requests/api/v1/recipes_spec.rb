require 'rails_helper'

RSpec.describe 'Api::V1::Recipes', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/recipes/index'

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    # TODO: Should configure FactoryBot to create a valid recipe
    let(:valid_attributes) do
      {
        title: 'Test Recipe',
        cook_time_in_minutes: 10,
        prep_time_in_minutes: 10,
        ratings: 5
      }
    end
    let(:recipe) { Recipe.create!(valid_attributes) }

    it 'returns http success' do
      get "/api/v1/recipes/show/#{recipe.id}"

      expect(response).to have_http_status(:success)
    end
  end

end
