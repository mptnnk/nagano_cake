class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  # 注文詳細画面（ステータス編集を兼ねる）
  def show
    @orders = Order.all
    @order = Order.find(params[:id])
    @customer = @order.customer
    @order_details = @order.order_details
  end
  
  # 注文ステータスの更新
  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    
    if @order.update(order_params)
      flash[:notice]="注文ステータスを更新しました"
      @order_details.update_all(making_status: 1) if @order.status == "payment_confirmation"
      redirect_to admin_order_path(@order.id)
    else
      flash[:alert]="注文ステータスの更新に失敗しました"
      render:show
    end
  end

  private
  
  def order_params
    params.require(:order).permit(:status)
  end

end
