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
    
    @cart_items = current_customer.cart_items
    # if cart_items = blank || 
    
    # もしカートアイテムが空だったら、アイテムを新規追加する
    # もしカートアイテムが空じゃなかったら、アイテムのIDが同じものがあればそこにamountを足す
    # もしカートアイテムが空じゃなかったら、アイテムのIDが同じものがなければアイテムを新規追加する
    
    # もしカートアイテムが空だったら、またははアイテムIDの同じものがなければ、アイテムを新規追加する
    # もしカートアイテムが空じゃなく、かつ、アイテムIDの同じものがあったら、amountを足す
    
    if @cart_items = blank?
      @cart_item.save
      redirect_to cart_items_path
    else
      
    
    @cart_items = current_customer.cart_items
    if @cart_items.blank?
      @cart_item = current_customer.cart_items.build(item_id: params[:cart_item][:item_id],amount: params[:cart_item][:amount])
    else
      @cart_item.amount += params[:cart_item][:amount].to_i
    end
    if @cart_items.save
      flash[:notice]="注文商品を追加しました"
      redirect_to cart_items_path
    else
      @item = Item.find_by(id: params[:cart_item][:item_id])
      redirect_to item_path(@item.id)
    end
  end
end
    # @cart_item = current_customer.cart_items.build(cart_item_params)
    # @cart_items = current_customer.cart_items
    # @cart_items.each do |cart_item|
    #   if cart_item.item_id == @cart_item.item_id
    #     new_amount = cart_item.amount + @cart_item.amount
    #     cart_item.update_attribute(:amount, new_amount)
    #     @cart_item.delete
    # #   end
    # @cart_item.save
    # redirect_to(cart_items_path)and return
    # end
  
  # カート内商品データ更新
  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      flash[:notice]="注文個数を変更しました"
      redirect_to cart_items_path
    else
      render:index
    end
  end
  
  # カート内商品データ削除（1商品）
  def destroy
    @cart_item = CartItem.find(params[:id])
    if @cart_item.destroy
      flash[:notice]="注文商品を削除しました"
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
