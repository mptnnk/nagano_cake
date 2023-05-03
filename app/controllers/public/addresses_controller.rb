class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_address, only: [:edit, :update, :destroy]

  # 配送先登録/一覧画面
  def index
    @address = Address.new
    # @addresses = Address.where(customer_id: current_customer.id)
    @addresses = current_customer.addresses
  end

  def create
    @addresses = current_customer.addresses
    @address = Address.new(address_params)
    # @address.customer_id = current_customer.id
    # 模範回答ではidをここで読んでいるけど、もともとストロングパラメータのmergeで読んでいるので、このコードがなくてもいけるかも？
    @address.save ? (redirect_to addresses_path) : (render :index)
    # if @address.save!
    #   flash[:notice]="配送先を登録しました"
    #   redirect_to addresses_path
    # else
    #   render:index
    # end
  end

  # 配送先編集画面
  def edit
    # @address = Address.find(params[:id])
  end

  # 配送先の更新
  def update
    @address.update(address_params) ? (redirect_to addresses_path) : (render :edit)
    # @address = Address.find(params[:id])
    # if @address.update(address_params)
    #   flash[:notice]="配送先の変更が保存されました"
    #   redirect_to addresses_path
    # else
    #   render:index
    # end
  end

  # 配送先の削除
  def destroy
    # @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:name, :postal_code, :address).merge(customer_id :current_customer.id)
  end
  
  def ensure_address
    @addresses = current_customer.addresses
    @address = @addresses.find_by(id: params[:id])
    redirect_to addresses_path unless @address
  end

end
