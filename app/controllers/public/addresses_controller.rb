class Public::AddressesController < ApplicationController
  # 配送先登録/一覧画面
  def index
    @address = Address.new
    @addresses = Address.all
  end

  def create
    @address = Address.new(address_params)
    if @address.save!
      flash[:notice]="配送先を登録しました"
      redirect_to addresses_path
    # else
      # render:index
    end
  end

  # 配送先編集画面
  def edit
  end

  # 配送先の更新
  def update
  end

  # 配送先の削除
  def destroy
  end

  private

  def address_params
    params.require(:address).permit(:name,:postal_code,:address).merge(customer_id:current_customer.id)
  end

end
