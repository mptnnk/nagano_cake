class Item < ApplicationRecord
  has_many:cart_items,dependent: :destroy
  has_many:order_details,dependent: :destroy
  belongs_to:genre

  validates:is_active,inclusion:[true,false]

  has_one_attached :cake_image

  def with_tax_price
    (price*1.1).floor
  end
  # floorで小数点以下を切り捨てる

  def get_image
    unless cake_image.attached?
     file_path = Rails.root.join('app/assets/images/default-image.jpg')
     cake_image.attach(io:File.open(file_path),filename:'default-image.jpg',content_type:'image/jpg')
    end
    cake_image
  end

end
