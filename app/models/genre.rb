class Genre < ApplicationRecord
  # has_many:items,dependent: :destroy
  has_many :items
  # dependet: :destroyを削除
  scope :only_active, -> { where(is_active: true) }
  # is_activeがtrueのジャンルのみ取り出すscopeメソッド
  
  validates :name, presence: true, uniqueness: true
  
end
