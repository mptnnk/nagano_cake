class Admin::OrdersController < ApplicationController
  # 注文詳細画面（ステータス編集を兼ねる）
  def show
    @order = Order.all
  end
  
  # 注文ステータスの更新
  def update
  end
end
