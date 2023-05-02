class Order < ApplicationRecord
  
  belongs_to :customer
  has_many :order_details
  # dependent: :destroyを削除。注文詳細が消えたからといって注文履歴を消さなくていいやんってことかな？
  has_many :items, through: :order_details
  # 注文詳細を通じてたくさんの商品情報を有している。ということか、、
  
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :name, presence: true
  validates :shipping_cost, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :total_payment, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  
  scope :ordered_today, -> { where(created_at: Time.current.at_beginning_of_day..Time.current.at.end_of_day) }
  # beginning_of_dayはその日のタイムスタンプを返すactive supportのメソッド。Time.currentは「今日」。
  # つまりこれは今日のはじまりから終わりまでの間に作成されたオーダーをスコープするメソッド＝ordered_today
  
  enum payment_method:{
    credit:0,
    bank:1
  }
  
  enum status:{
    payment_waiting:0,
    payment_confirmation:1,
    in_production:2,
    preparing_deliver:3,
    deliverd:4
  }
  
  def get_shipping_informations_from(resource)
    class_name = resource.class.name
    if class_name == 'Customer'
    # resource: Customer
      self.postal_code = resource.postal_code
      self.address = resource.address
      self.name = resource.full_name
    elsif class_nae == 'Address'
    # resource: Address
      self.postal_code = resource.postal_code
      self.address = resource.address
      self.name = resource.name
    end
  end
  
  def create_order_details(customer)
    unless order_details.first
      cart_items = customer.cart_items.includes(:item)
      # includesは関連するテーブルをまとめて取得するメソッド。
      cart_items.each do |cart_item|
        item = cart_item.item
        OrderDetail.create!(
          order_id: id,
          item_id: item.id,
          order_price: item.with_tax_price,
          amount: cart_item.amount
        )
      end
      cart_items.destroy_all
    end
  end
  
  def are_all_details_completed?
    (order_details.completed.count == order_details.count) ? true : false
  end

end
