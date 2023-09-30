class Recipe < ApplicationRecord
  validates :title, presence: true
  # Hopefully, you will not need more than a day to cook or prep a recipe.
  validates :cook_time_in_minutes, numericality: { in: 1..1440 }
  validates :prep_time_in_minutes, numericality: { in: 1..1440 }
  validates :ratings, numericality: { in: 0..5 }, allow_nil: true
end
