class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :cook_time_in_minutes, :prep_time_in_minutes,
             :ratings, :category, :cuisine, :author, :image_url

  def attributes(*args)
    data = super
    data.deep_transform_keys { |key| key.to_s.camelize(:lower) }
  end

  def image_url
    object.image_url || ActionController::Base.helpers.asset_path('recipe/image.webp')
  end
end
