class Public::ItemsController < ApplicationController
  # 商品一覧
  def index
    @genres = Genre.only_active
    # only_activeはGenreモデルで定義あり
    # @items = Item.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      all_items = @genre.items
      # @items = @genre.items.where(is_active: true).page(params[:page]).per(8)
      # @items_count = @genre.items.where(is_active: true).count
    # elsif params[:search]
    #   @search = Item.search(params[:search])
    #   @items = @search.page(params[:page])
    #   @items_count = @items.count
    else
      all_items = Item.where_genre_active.includes(:genre)
      # where_genre_activeはItemモデルで定義あり
      # @items = Item.where(is_active: true).page(params[:page]).per(8)
      # @items_count = Item.count
    end
    @items = all_items.page(params[:page]).per(8)
    @all_items_count = all_items.count
  end

  # 商品詳細
  def show
    @item = Item.where_genre_active.find(params[:id])
    # where_genre_activeはItemモデルで定義あり
    # @item = Item.find(params[:id])
    @genres = Genre.only_active
    # only_activeはGenreモデルに
    # @genres = Genre.all
    @cart_item = CartItem.new
  end

end