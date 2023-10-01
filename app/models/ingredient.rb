class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save :downcase_name, if: -> { name_changed? }

  private

  def downcase_name
    self.name = name.downcase
  end
end
