class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  # 注文詳細画面（ステータス編集を兼ねる）
  def show
    @orders = Order.all
    @order = Order.find(params[:id])
    @customer = @order.customer
  end
  
  # 注文ステータスの更新
  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:notice]="注文ステータスを更新しました"
      redirect_to admin_order_path(@order.id)
    else
      render:show
    end
  end
  
  private
  
  def order_params
    params.require(:order).permit(:status)
  end

end
