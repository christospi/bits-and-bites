class Recipe < ApplicationRecord
  has_many :recipes_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipes_ingredients

  validates :title, presence: true
  # Hopefully, you will not need more than a day to cook or prep a recipe.
  validates :cook_time_in_minutes, numericality: { in: 0..1440 }
  validates :prep_time_in_minutes, numericality: { in: 0..1440 }
  validates :ratings, numericality: { in: 0..5 }, allow_nil: true

  scope :includes_ingredients, -> { includes(recipes_ingredients: :ingredient) }
  scope :order_by_ratings, -> { order(ratings: :desc, id: :desc) }
end
