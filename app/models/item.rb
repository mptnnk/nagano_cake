class Item < ApplicationRecord
  has_many:cart_items,dependent: :destroy
  has_many:order_details,dependent: :destroy
  belongs_to:genres

  has_one_attached :image
  
  def image
    unless image.attached?
     file_path = Rails.root.join('app/assets/images/default-image.jpg')
     image.attach(io:File.open(tile_path),filename:'default-image.jpg',content_type:'image/jpg')
    end
    image
  end
  
end
