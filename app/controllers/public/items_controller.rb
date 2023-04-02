class Public::ItemsController < ApplicationController
  # 商品一覧
  def index
    @genres = Genre.all
    # @items = Item.all
    if params[:genre_id]
      @item_genre = Genre.find(params[:gernre_id]).items
      @items = @item_genre.page(params[:page])
      @items_count = @items_genre.count
    elsif params[:search]
      @search = Item.search(params[:search])
      @items = @search.page(params[:page])
      @items_count = @items.count
    else
      @items = Item.page(params[:page])
      @items_count = Item.count
    end
  end

  # 商品詳細
  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
  
end