class Admin::HomesController < ApplicationController
  # 管理者トップページ（注文履歴一覧）
  def top
    @order = Order.all
  end
end
