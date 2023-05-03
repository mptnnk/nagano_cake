class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_order, only: [:show, :update]
  
  def index
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.page(params[:page]).reverse_order
    elsif params[:created_at] == "today"
      @orders = Order.ordered_today.includes(:customer).page(params[:page]).reverse_order
      # ordered_torayはOrderモデルでscope定義している
    else
      @orders = Order.includes(:customer).page(params[:page]).reverse_order
    end
  end
  
  # 注文詳細画面（ステータス編集を兼ねる）
  def show
    # @orders = Order.all
    # @order = Order.find(params[:id])
    @customer = @order.customer
    @order_details = @order.order_details.includes(:item)
  end
  
  # 注文ステータスの更新
  def update
    if @order.update(order_params) && @order.confirm_deposit?
      @order.order_details.update_all(making_status: 1)
    end
    redirect_to admin_order_path(@order)
    
    # @order = Order.find(params[:id])
    # @order_details = @order.order_details
    
    # if @order.update(order_params)
    #   flash[:notice]="注文ステータスを更新しました"
    #   @order_details.update_all(making_status: 1) if @order.status == "payment_confirmation"
    #   redirect_to admin_order_path(@order.id)
    # else
    #   flash[:alert]="注文ステータスの更新に失敗しました"
    #   render:show
    # end
  end

  private
  
  def order_params
    params.require(:order).permit(:status)
  end
  
  def ensure_order
    @order = Order.find(params[:id])
  end

end
