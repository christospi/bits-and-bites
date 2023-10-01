require 'rails_helper'

RSpec.describe RecipeSearchService do
  describe '#call' do
    subject(:service) { described_class.new(ingredients) }

    let(:ingredients) { 'milk, butter' }

    context 'when there are no recipes' do
      it 'returns an empty ActiveRecord::Relation' do
        expect(service.call).to be_empty
      end
    end

    context 'when there are recipes that include the ingredients' do
      # TODO: For god's sake, add factories for these models!
      let!(:recipe1) { Recipe.create(title: 'R1', cook_time_in_minutes: 1, prep_time_in_minutes: 1) }
      let!(:recipe2) { Recipe.create(title: 'R2', cook_time_in_minutes: 1, prep_time_in_minutes: 1) }
      let!(:recipe3) { Recipe.create(title: 'R3', cook_time_in_minutes: 1, prep_time_in_minutes: 1) }

      let!(:ingredient1) { Ingredient.create(name: 'milk') }
      let!(:ingredient2) { Ingredient.create(name: 'butter') }
      let!(:ingredient3) { Ingredient.create(name: 'sugar') }

      before do
        recipe1.ingredients << ingredient1
        recipe1.ingredients << ingredient2

        recipe2.ingredients << ingredient1
        recipe2.ingredients << ingredient2
        recipe2.ingredients << ingredient3

        recipe3.ingredients << ingredient1
        recipe3.ingredients << ingredient3
      end

      it 'returns the recipe and exactly matches the ingredients' do
        expect(service.call).to eq([recipe1])
      end
    end
  end
end
