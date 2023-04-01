class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!
  # 制作ステータスの更新
  # order_detail 2 in_production / order 2 in_production
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    
    @order_detail.update(order_detail_params)
    if @order_detail.making_status == "in_production"
      @order.update(status: 2)
      flash[:notice]="製作ステータスを更新しました"
      redirect_to admin_order_path(@order.id)
    elsif @order.order_details.count == @order.order_details.where(making_status: "production_comp").count
      @order.update(status: 3)
      flash[:notice]="ステータスを発送準備中に更新しました"
      redirect_to admin_order_path(@order.id)
    else
      flash[:notice]="製作ステータスを更新しました"
      redirect_to admin_order_path(@order.id)
    end
  end
  
  private
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
end
