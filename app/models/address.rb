class Address < ApplicationRecord
  belongs_to:customer
  validates :customer_id, presence: true
  validates :postal_code, length: {minimum:7, maximum:7}

  def address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end
end