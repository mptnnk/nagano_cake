class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
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
      render:index
    end
  end

# ジャンル編集画面
  def edit
    @genre = Genre.find(params[:id])
  end
  
# ジャンルデータ更新
  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      flash[:notice]="ジャンルのデータ更新に成功しました"
      redirect_to admin_genres_path
    else
      render:edit
    end
  end
  
  private
  
  def genre_params
    params.require(:genre).permit(:name)
  end

end
