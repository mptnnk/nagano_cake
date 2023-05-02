class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_customer, only: [:show, :edit, :update]
  # ensure_customerでcustomer.find(params[:id])を定義しているので、いちいち各アクションで定義する必要がない。
  
  # 顧客一覧画面
  def index
    @customers = Customer.page(params[:page]).per(10)
  end

# 顧客詳細画面
  def show
    # @customer = Customer.find(params[:id])
  end

# 顧客編集画面
  def edit
    # @customer = Customer.find(params[:id])
  end
  
  # 顧客情報
  def update
    @customer.update(customer_params) ? (redirect_to admin_customer_path(@customer)) : (render :edit)
    # もし@customerをアップデートしたらadmin_customer_pathへ、そうでなければrenderへということのよう。
    # この場合フラッシュメッセージは実装できないのかな？
    
    # @customer = Customer.find(params[:id])
    # if @customer.update(customer_params)
    #   flash[:notice]="顧客情報の変更に成功しました"
    #   redirect_to admin_customer_path(@customer.id)
    # else
    #   flash[:notice]="顧客情報の変更に失敗しました"
    #   render:update
    # end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:email,:postal_code,:address,:telephone_number,:is_active)
  end
  # is_deletedをis_activeに変更。defaultはtrueです
  
  def ensure_customer
    @customer = Customer.find(params[:id])
  end
  
end
