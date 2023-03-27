class Public::OrdersController < ApplicationController
  
  # 注文情報入力画面（支払方法・配送先選択）
  def new
    if current_customer.cart_items.blank?
      flash[:alert]="注文する商品をカートに入れてください"
      redirect_to root_path
    else
      @order = Order.new
      @customer = current_customer
    end
  end

  # 注文情報確認画面
  def confirm
    @order = Order.new(order_params)
  end

  # 注文完了画面
  def thanks
  end

  # 注文確定処理
  def create
    @order = Order.new(params[:order_params])
  end

  # 注文履歴画面
  def index
    @orders = current_customer.orders.all
  end

  # 注文履歴詳細画面
  def show
  end
  
  private
  
  def order_params
    params.require(:order).permit(:shipping_cost,:total_payment,:payment_method,:postal_code,:address,:name,:status).merge(customer_id:current_customer.id)
  end
end
