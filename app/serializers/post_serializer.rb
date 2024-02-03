class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :body, :image_url
  has_one :user

  private
  def image_url
    url_for(object.image) if object.image.attached?
  end

end
