class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_item, only: [:show, :edit, :update]
  # ensure_itemをprivate以下で定義しているので、各メソッドで@itemを定義する必要がない
  
  # 商品の新規登録画面
  def new
    @item = Item.new
    @genres = Genre.all
    # フォームに@genresを選択する箇所があるので
  end
  
  # 商品一覧
  def index
    # @items = Item.all.page(params[:page]).per(10)
    if params[:genre_id]
      # もしビューファイルからgenre_idの受け渡しがあったら
      @genre = Genre.find(params[:genre_id])
      # @genreは全ジャンルからidで探したものを指定する
      all_items = @genre.items
      # そのときall_itemsは上述で指定した@genreと紐づくitemを全て呼ぶものとして定義する
    else
      all_items = Item.includes(:genre)
      # もしビューファイルからgenre_idの受け渡しがなければ、all_itemsの定義はジャンルテーブルのデータを含むitemとして定義する
    end
    
    @items = all_items.page(params[:page]).per(10)
    # 上段のif式で定義したall_itemsどちらかを読み込む
    @all_items_count = all_items.count
  end

# 商品情報の新規登録
  def create
    @item = Item.new(item_params)
    @item.save ? (redirect_to admin_item_path(@item)) : (render :new)
    # a ? b : c は「aが真ならばb、さもなくばc」という意味
    
    # @item = Item.new(item_params)
    # # @item.genre_id = params[:item][:genre_id].to_i
    # if @item.save!
    #   flash[:notice]="商品の新規登録に成功しました"
    #   redirect_to admin_item_path(@item.id)
    # else
    #   render:new
    # end
  end

# 商品詳細画面
  def show
    # @item = Item.find(params[:id])
  end

# 商品編集画面
  def edit
    # @item = Item.find(params[:id])
    @genres = Genre.all
    # newアクションと同様、editのビューで@genresを選択するフォームがあるので指定している
  end

  # 商品情報の更新
  def update
    @item.update(item_params) ? (redirect_to admin_item_path(@item)) : (render :edit)
    
    # @item = Item.find(params[:id])
    # if @item.update(item_params)
    #   flash[:notice]="商品の変更が保存されました"
    #   redirect_to admin_items_path
    # else
    #   render:edit
    # end
  end

  private

  def item_params
    params.require(:item).permit(:genre_id,:cake_image,:name,:introduction,:price,:is_active)
  end
  
  def ensure_item
    @item = Item.find(params[:id])
  end

end
