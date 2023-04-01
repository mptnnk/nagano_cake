class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!
  # 制作ステータスの更新
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    if @order_detail.update(order_detail_params)
      flash[:notice]="制作ステータスを更新しました"
      redirect_to admin_order_path(@order.id)
    else
      flash[:alert]="制作ステータスの更新に失敗しました"
      redirect_to admin_order_path(@order.id)
    end
  end
  
  private
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
end
