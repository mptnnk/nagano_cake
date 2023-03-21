class Public::CartItemsController < ApplicationController
  # カート内商品一覧画面（数量変更・カート削除の要素を含む）
  def index
    @cart_item = Cart.item.new
    @cart_items = Cart_item.where(customer_id: current_customer.id)
  end
  
  # カート内商品データ追加
  def create
    @cart_item = Cart_item.new(cart_item_params)
    if @cart_item.save
      flash[:notice]="商品を追加しました。"
      redirect_to cart_items_path
    end
  end
  
  
  # カート内商品データ更新
  def update
  end
  
  # カート内商品データ削除（1商品）
  def destroy
  end
  
  # カート内商品データ削除（全て）
  def destroy_all
  end
  
  def cart_item_params
    params.require(:cart_item).permit(:item_id,:amount).merge(customer_id:current_customer.id)
  end
  
end
