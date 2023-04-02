class Public::ItemsController < ApplicationController
  # 商品一覧
  def index
    @genres = Genre.all
    # @items = Item.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @items = @genre.items.page(params[:page])
      @items_count = @genre.items.count
    # elsif params[:search]
    #   @search = Item.search(params[:search])
    #   @items = @search.page(params[:page])
    #   @items_count = @items.count
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