class Public::AddressesController < ApplicationController
  # 配送先登録/一覧画面
  def index
    @addresses = Address.all
  end

  # 配送先編集画面
  def edit
  end

  # 配送先の登録
  def create
  end

  # 配送先の更新
  def update
  end

  # 配送先の削除
  def destroy
  end
  
  private
  
  def address_params
    params.require(:address),permit(:customer_id,:name,:postal_code,:address)

end
