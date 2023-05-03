class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_genre, only: [:show, :edit, :update]
  # ensure_genreで@genre = Genre.find(params[:id])を定義しているので各アクションで定義する必要がないようだ。
  
  # ジャンル管理画面（一覧・追加を兼ねる）
  def index
    @genre = Genre.new
    @genres = Genre.all
  end
  
  # ジャンル新規登録
  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:notice]="ジャンルの新規登録に成功しました"
      redirect_to admin_genres_path
    else
      @genres = Genre.all
      render :index
    end
  end

# ジャンル編集画面
  def edit
    # @genre = Genre.find(params[:id])
    # ensure_genreで定義済みのため記載する必要なし
  end
  
# ジャンルデータ更新
  def update
    # @genre = Genre.find(params[:id])
    # if @genre.update(genre_params)
    #   flash[:notice]="ジャンルのデータ更新に成功しました"
    #   redirect_to admin_genres_path
    if @genre.update(genre_params)
      unless @genre.is_active
      # unlessは「unless 条件式」と書いて「条件式がfalseなら処理を実行」という意味
      # この場合、ジャンルのis_activeはデフォルトtrueのため、unlessにより「genreのis_activeがfalseの場合は」ということになる
        @genre.items.update_all(is_active: false)
        # 該当ジャンルの全アイテムのis_activeをfalseに変更
      end
      redirect_to admin_genres_path
      # ifからここまで変更
    else
      render :edit
    end
  end
  
  private
  
  def genre_params
    params.require(:genre).permit(:name, :is_active)
  end
  # is_activeを追加
  
  def ensure_genre
    @genre = Genre.find(params[:id])
  end

end
