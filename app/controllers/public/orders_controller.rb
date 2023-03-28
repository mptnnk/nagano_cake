class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  # 注文情報入力画面（支払方法・配送先選択）
  def new
    if current_customer.cart_items.blank?
      flash[:notice]="注文する商品をカートに入れてください"
      redirect_to items_path
    else
      @order = Order.new
      @customer = current_customer
    end
  end

  # 注文情報確認画面
  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.payment_method = params[:order][:payment_method]
    @total_price = @cart_items.inject(0){|sum,cart_item|sum+cart_item.subtotal}
    # subtotal = item.with_tax_price*amount(cartitemモデル定義)
    # with_tax_price = (price*1.1).floor(itemモデル定義)
    @order.shipping_cost = 800
    @order.total_payment = @total_price + @order.shipping_cost

    if params[:order][:select_address] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name

    elsif params[:order][:select_address] == "1"
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name

    elsif params[:order][:select_address] == "2"

    end

  end

  # 注文完了画面
  def thanks
  end

  # 注文確定処理
  def create
    @order = Order.new(order_params)
    if @order.save
      @cart_items = current_customer.cart_items
      
      @cart_items.destroy_all
      redirect_to orders_thanks_path
    else
      render:new
    end
  end

  # 注文履歴画面
  def index
    @order = Order.find(params[:id])
    @orders = current_customer.orders.all
  end

  # 注文履歴詳細画面
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
  end

  private

  def order_params
    params.require(:order).permit(:shipping_cost,:total_payment,:payment_method,:postal_code,:address,:name,:status).merge(customer_id:current_customer.id)
  end

end
