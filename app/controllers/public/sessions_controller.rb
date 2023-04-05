# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :customer_state, only:[:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in,keys:[:email])
  end

  def customer_state
  # 退会しているかを判断するメソッド
    @customer = Customer.find_by(email: params[:customer][:email])
    # 入力されたemailからアカウントを1件取得
    return if !@customer
    # アカウントを取得できなかった婆、このメソッドを終了する（！は否定演算子）
    if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted == true
    # 取得したアカウントのパスワードと入力されたパスワードが一致、かつis_deletedがtrue(=退会済み)の場合
      flash[:alert]="退会済みです。再登録のうえご利用ください。"
      redirect_to new_customer_registration_path
    end
  end

end