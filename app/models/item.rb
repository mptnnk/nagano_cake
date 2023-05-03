class Item < ApplicationRecord
  
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :genre
  
  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  # 0より大きい整数であること
  validate :image_type
  # validate（単数形）は自分でバリデーション定義するときに使う。privateの下に定義あり

  # validates:is_active,inclusion:[true,false]
  scope :where_genre_active, -> { joins(:genre).where(genres: { is_active: true}) }
  # ジャンルテーブルと結合させて、ジャンルのis_activeがtrueのものを呼び出せるスコープをかける

  has_one_attached :cake_image

  def get_cake_image(*size)
    unless cake_image.attached?
     file_path = Rails.root.join('app/assets/images/default-image.jpg')
     cake_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    
    if !size.empty?
      cake_image.variant(resize: size)
      # variantはactivestorageの、blob型のデータに対して使えるメソッド。
      # このメソッドで、activestorage経由で保存したデータのリサイズや回転などの処理を行うことができる。
      # 今回の場合はcake_imageのサイズ指定がない場合には勝手にリサイズしろよということだと思う。
    else
      cake_image
    end
  end
  
  def with_tax_price
    (price*1.1).floor
  end
  # floorで小数点以下を切り捨てる
  # ceilは切り上げ、roundは四捨五入
  
  def self.recommended
  # selfはクラスメソッドとなるのでレシーバself＝Itemということになる（多分）
    recommends = []
    active_genres = Genre.only_active.includes(:items)
    # includesは関連するテーブルをまとめて取得するメソッド。
    # only_activeはgenreモデルに定義してあるメソッドで、is_activeがtrueのものだけを取り出すメソッド
    # SELECT "genres".* FROM "genres.only_active"
    # SELECT "genres".* FROM "genres.only_active" WHERE "items"."id" IN (1,2,3..)
    # つまりアクティブなジャンルのうちアイテムIDを保有するもののみが抽出される（非アクティブなジャンルまたはアイテムを保有しないジャンルは抽出されない）
    active_genres.each do |genre|
      item = genre.items.last
      recommends << item if item
    end
    recommends
  end
  
  private
  
  def image_type
    if !cake_image.blob
      # blobはactivestorageで使えるデータ型。画像、音声、圧縮ファイルなどの容量の大きいデータを保存するためのもの。
      # 今回のメソッドでは否定演算子がついているのでイメージがもし添付されていなければのパターンだと思う。
      errors.add(:cake_image, 'をアップロードしてください')
    elsif !cake_image.blob.content_type.in?(%('image/jpeg image/png'))
      # もしくはイメージのタイプがjpegかpngでなかったらのパターン。
      errors.add(:cake_image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end

end
