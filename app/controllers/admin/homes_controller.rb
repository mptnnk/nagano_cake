class Admin::HomesController < ApplicationController
  # 管理者トップページ（注文履歴一覧）
  def top
    @order_details = OrderDetail.all
  end
end