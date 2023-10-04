class Ingredient < ApplicationRecord
  include PgSearch::Model

  has_many :recipes_ingredients, dependent: :destroy
  has_many :recipes, through: :recipes_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save :downcase_name, if: -> { name_changed? }

  pg_search_scope :search_by_name, against: :name

  private

  def downcase_name
    self.name = name.downcase
  end
end
