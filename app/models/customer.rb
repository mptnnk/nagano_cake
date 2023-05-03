class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :addresses, dependent: :destroy
  # has_many :orders, dependent: :destroy
  has_many :orders
  # dependent: :destroyを削除
  has_many :cart_items, dependent: :destroy
  
  scope :only_active, -> { where(is_active: true) }
  
  # validates:name,presence:true,length:{minimum:2,maximum:20}
  
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  # カナは全角カタカナしか登録できなくなった
  validates :email, presence: true, uniqueness: true
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  
  def full_name
    last_name + " " + first_name
  end
  
  def full_name_kana
    last_name_kana + " " + first_name_kana
  end
  
  def has_in_cart(item)
    cart_items.find_by(item_id: item.id)
  end
  
end
