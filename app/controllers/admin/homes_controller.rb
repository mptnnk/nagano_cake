class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  # 管理者トップページ（注文履歴一覧）
  def top
    @orders = Order.all
  end
end