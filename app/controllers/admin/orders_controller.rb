class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  # 注文詳細画面（ステータス編集を兼ねる）
  def show
    @orders = Order.all
    @order = Order.find(params[:id])
  end
  
  # 注文ステータスの更新
  def update
  end
end
