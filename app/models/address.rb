class Address < ApplicationRecord
  
  belongs_to :customer
  
  # validates :customer_id, presence: true
  # validates :postal_code, length: {minimum:7, maximum:7}
  validates :postal_code, presence: true, format: {with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :name, presence: true

  def address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end
end