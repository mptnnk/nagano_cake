class Public::ItemsController < ApplicationController
  # 商品一覧
  def index
    @items = Item.all
  end

  # 商品詳細
  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
end