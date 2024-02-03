class RestaurantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :menu, :image_url

  def image_url
    url_for(object.image) if object.image.attached?
  end
end
