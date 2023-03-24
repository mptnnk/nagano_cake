class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  # カート内商品一覧画面（数量変更・カート削除の要素を含む）
  def index
    @cart_item = CartItem.new
    # @cart_items = CartItem.where(customer_id: current_customer.id)
    @cart_items = current_customer.cart_items
    @total_price = 0
  end
  
  
  # カート内商品データ追加
  def create
    @cart_item = current_customer.cart_items.build(cart_item_params)
    @cart_items = current_customer.cart_items.all
    @cart_items.each do |cart_item|
      if cart_item.item_id == @cart_item.item_id
        new_amount = cart_item.amount + @cart_item.amount
        cart_item.update_attribute(:amount,new_amount)
        @cart_item.delete
      end
    end
    @cart_item.save
    redirect_to cart_items_path,notice:"商品を追加しました"
  end
  
  # カート内商品データ更新
  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path,notice:"注文個数を変更しました"
    else
      render:index,notice:"注文個数の変更ができませんでした"
    end
  end
  
  # カート内商品データ削除（1商品）
  def destroy
    @cart_item = CartItem.find(params[:id])
    if @cart_item.destroy
      flash[:notice]="商品を削除しました"
      redirect_to cart_items_path
    end
  end
  
  # カート内商品データ削除（全て）
  def destroy_all
    if current_customer.cart_items.destroy_all
      redirect_to cart_items_path
    else
      render:index
    end
  end
  
  def cart_item_params
    params.require(:cart_item).permit(:item_id,:amount).merge(customer_id:current_customer.id)
  end
  
end