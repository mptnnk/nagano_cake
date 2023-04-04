class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  # 顧客一覧画面
  def index
    @customers = Customer.page(params[:page]).per(10)
  end

# 顧客詳細画面
  def show
    @customer = Customer.find(params[:id])
  end

# 顧客編集画面
  def edit
    @customer = Customer.find(params[:id])
  end
  
  # 顧客情報
  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice]="顧客情報の変更に成功しました"
      redirect_to admin_customer_path(@customer.id)
    else
      flash[:notice]="顧客情報の変更に失敗しました"
      render:update
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:email,:postal_code,:address,:telephone_number,:is_deleted)
  end
    
end
