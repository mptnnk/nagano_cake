class Public::CustomersController < ApplicationController
  # 顧客のマイページ
  def show
    @customer = current_customer
  end

  # 顧客の登録情報編集画面
  def edit
  end
  
  # 顧客の登録情報更新
  def update
  end

# 　顧客の退会確認画面
  def unsubscribe
  end
  
  # 顧客の退会処理（ステータス更新）
  def withdraw
  end
  
end
