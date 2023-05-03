class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_curernt_customer
  
  # 顧客のマイページ
  def show
    # @customer = current_customer
  end

  # 顧客の登録情報編集画面
  def edit
    # @customer = current_customer
  end
  
  # 顧客の登録情報更新
  def update
    # @customer = current_customer
    if @customer.update(customer_params)
      redirect_to customers_my_page_path, notice: '会員情報を更新しました'
      # flash[:notice]="会員情報を更新しました"
      # redirect_to customers_my_page_path
    else
      render:edit
    end
  end

# 　顧客の退会確認画面
  def unsubscribe
    # @customer = current_customer
  end
  
  # 顧客の退会処理（ステータス更新）
  def withdraw
    # @customer = current_customer
    @customer.update(is_active: false)
    reset_session
    flash[:notice]="退会が完了しました。"
    redirect_to root_path
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:email,:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:telephone_number,:is_active)
  end
  
  def set_current_customer
    @customer = current_customer
  end
  
end
