class OrderDetail < ApplicationRecord
  enum making_status:{
    cant_start:0,
    waiting_start:1,
    in_production:2,
    production_comp:3
  }
  
  belongs_to :order
  belongs_to :item
  
  validates :item_id, uniqueness: { scope: :order_id }
  # 同一の注文IDのなかでは商品IDが一意であること。
  validates :order_price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  # 注文金額がゼロ以上の数値であること。
  validates :amount, presence: true, :numericality => { :greater_than_or_equal_to => 1 }
  # 注文個数が1以上の数値であること。
  
  def subtotal
    order_price * amount
  end
  
end
