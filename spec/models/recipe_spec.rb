require 'rails_helper'

RSpec.describe Recipe, type: :model do
  # TODO: Should configure FactoryBot to create a valid recipe
  let(:valid_attributes) do
    {
      title: 'Test Recipe',
      cook_time_in_minutes: 10,
      prep_time_in_minutes: 10,
      ratings: 5
    }
  end

  it 'is valid with valid attributes' do
    expect(described_class.new(valid_attributes)).to be_valid
  end

  it 'is not valid without a title' do
    valid_attributes[:title] = nil
    expect(described_class.new(valid_attributes)).not_to be_valid
  end

  it 'is not valid without a cook_time_in_minutes' do
    valid_attributes[:cook_time_in_minutes] = nil
    expect(described_class.new(valid_attributes)).not_to be_valid
  end

  it 'is not valid without a prep_time_in_minutes' do
    valid_attributes[:prep_time_in_minutes] = nil
    expect(described_class.new(valid_attributes)).not_to be_valid
  end

  it 'is not valid with a cook_time_in_minutes out of range' do
    valid_attributes[:cook_time_in_minutes] = 1441
    expect(described_class.new(valid_attributes)).not_to be_valid
  end

  it 'is not valid with a prep_time_in_minutes out of range' do
    valid_attributes[:prep_time_in_minutes] = 1441
    expect(described_class.new(valid_attributes)).not_to be_valid
  end

  it 'is not valid with a ratings out of range' do
    valid_attributes[:ratings] = 6
    expect(described_class.new(valid_attributes)).not_to be_valid
  end
end
