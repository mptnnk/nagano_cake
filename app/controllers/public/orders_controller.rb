class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_cart_items, only: [:new, :confirm, :create, :error]

  # 注文情報入力画面（支払方法・配送先選択）
  def new
    if current_customer.cart_items.blank?
      flash[:notice]="注文する商品をカートに入れてください"
      redirect_to items_path
    else
      @order = Order.new
      # @customer = current_customer
    end
  end

  # 注文情報確認画面
  def confirm
    @order = Order.new(order_params)
    if params[:select_address] == '0'
      @order.get_shipping_informations_from(current_customer)
    elsif params[:select_address] == '1'
      @selected_address = current_customer.address.find(params[:address_id])
      @order.get_shipping_informations_from(@selected_address)
    elsif params[:select_address] =- '2' && (@order.postal_code =~ /\A\d{7}\z/) && @order.address? && @order.name?
      # 処理なし
    else
      flash[:error] = "情報を正しく入力してください"
      render :new
    end
    # @cart_items = current_customer.cart_items
    # @order = Order.new(order_params)
    # @order.payment_method = params[:order][:payment_method]
    # @total_price = @cart_items.inject(0){|sum,cart_item|sum+cart_item.subtotal}
    # # subtotal = item.with_tax_price*amount(cartitemモデル定義)
    # # with_tax_price = (price*1.1).floor(itemモデル定義)
    # @order.shipping_cost = 800
    # @order.total_payment = @total_price + @order.shipping_cost
    # if params[:order][:select_address] == "0"
    #   @order.postal_code = current_customer.postal_code
    #   @order.address = current_customer.address
    #   @order.name = current_customer.last_name + current_customer.first_name
    # elsif params[:order][:select_address] == "1"
    #   @address = Address.find(params[:order][:address_id])
    #   @order.postal_code = @address.postal_code
    #   @order.address = @address.address
    #   @order.name = @address.name
    # elsif params[:order][:select_address] == "2"
    # end
  end
  
  def error
  end

  # 注文完了画面
  def thanks
  end

  # 注文確定処理
  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @order.total_payment = @order.shipping_cost + @cart_items.sum(&:subtotal)
    if @order.save
      @order.create_order_details(current_customer)
      # create_order_detailsはOrderモデルで定義済み
      redirect_to thanks_path
    else
      render :new
    end
    # @order = Order.new(order_params)
    # @order.status = 0
    # if @order.save
    #   @cart_items = current_customer.cart_items
    #   @cart_items.each do |cart_item|
    #     order_detail = OrderDetail.new
    #     order_detail.order_id = @order.id
    #     order_detail.item_id = cart_item.item_id
    #     order_detail.amount = cart_item.amount
    #     # order_detail.order_price = cart_item.item.price
    #     # item.priceは税抜価格
    #     order_detail.making_status = 0
    #     order_detail.save!
    #   end
    #   @cart_items.destroy_all
    #   redirect_to orders_thanks_path
    # else
    #   render:new
    # end
  end

  # 注文履歴画面
  def index
    # @orders = current_customer.orders.all
    @orders = current_customer.orders.includes(:order_details, :items).page(params[:page]).reverse_order
  end

  # 注文履歴詳細画面
  def show
    @order = current_customer.orders.find(params[:id])
    @order_details = @order.order_details.includes(:item)
    # if params[:id] == "confirm"
    #   flash[:alert]="注文確定画面は再読み込みできません。もう一度やり直してください。"
    #   redirect_to new_order_path
    # else
    # @order = Order.find(params[:id])
    # # @order_details = @order.order_details.all
    # end
  end

  private

  def order_params
    params.require(:order).permit(:shipping_cost,:total_payment,:payment_method,:postal_code,:address,:name,:status).merge(customer_id:current_customer.id)
  end
  
  def ensure_cart_items
    @cart_items = current_customer.cart_items.includes(:item)
    redirect_to items_path unless @cart_items.first
  end

end
