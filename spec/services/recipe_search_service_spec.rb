require 'rails_helper'

RSpec.describe RecipeSearchService do
  describe '#call' do
    subject(:search_result_ids) { described_class.new(keyphrase).call.pluck(:id) }

    let(:keyphrase) { 'milk, butter' }

    context 'when there are no recipes' do
      it 'returns no results' do
        expect(search_result_ids).to be_empty
      end
    end

    context 'when recipes exist' do
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

      it 'returns the recipe that exactly matches the ingredients' do
        expect(search_result_ids).to eq([recipe1.id])
      end

      context 'when there is also a recipe with less ingredients' do
        let!(:recipe4) { Recipe.create(title: 'R4', cook_time_in_minutes: 1, prep_time_in_minutes: 1) }

        before do
          recipe4.ingredients << ingredient1
        end

        it 'includes the recipe in the results' do
          expect(search_result_ids).to include(recipe4.id)
        end
      end

      context 'when an ingredient is specified multiple times' do
        let(:keyphrase) { 'milk, butter, milk' }

        it 'returns the recipe and exactly matches the unique ingredients' do
          expect(search_result_ids).to eq([recipe1.id])
        end
      end

      context 'when an empty string is passed' do
        let(:keyphrase) { '' }

        it 'returns no results' do
          expect(search_result_ids).to be_empty
        end
      end

      context 'when multiple commas with empty strings are passed' do
        let(:keyphrase) { ',,,' }

        it 'returns no results' do
          expect(search_result_ids).to be_empty
        end

        context 'when there are existing ingredients between empty strings' do
          let(:keyphrase) { 'milk,,,butter,,,' }

          it 'returns the recipe and exactly matches the ingredients' do
            expect(search_result_ids).to eq([recipe1.id])
          end
        end
      end

      context 'when there are ingredients that textually match the search' do
        let!(:ingredient4) { Ingredient.create(name: 'milk powder') }

        before do
          recipe1.ingredients = [ingredient2, ingredient4]
        end

        it 'returns the recipe and exactly matches the ingredients' do
          expect(search_result_ids).to eq([recipe1.id])
        end
      end
    end
  end
end
