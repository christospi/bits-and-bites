require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it 'downcases name before save' do
      ingredient = described_class.create(name: 'Milk')
      expect(ingredient.name).to eq('milk')
    end
  end
end
