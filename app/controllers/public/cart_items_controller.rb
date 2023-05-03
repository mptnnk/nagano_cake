class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: [:create, :update, :destroy]
  
  # カート内商品一覧画面（数量変更・カート削除の要素を含む）
  def index
    @cart_items = current_customer.cart_items.includes(:item)
    # @cart_item = CartItem.new
    # # @cart_items = CartItem.where(customer_id: current_customer.id)
    # @cart_items = current_customer.cart_items.all
    # @total_price = 0
  end

  # カート内商品データ追加
  def create
    if @cart_item
      new_amount = @cart_item.amount + cart_item_params[:amount]
      @cart_item.update(amount: new_amount)
      redirect_to cart_items_path
    else
      @cart_item = current_customer.cart_items.new(cart_item_path)
      @cart_item.item_id = @item.id
      if @cart_item.save
        redirect_to cart_items_path
      else
        render 'public/items/show'
      end
    end
    # @cart_item = current_customer.cart_items.build(cart_item_params)
    # # @item = Item.find(params[:cart_item][:item_id])
    # # if @cart_item.amount.nil?
    # #   flash[:notice]="個数を選択してください"
    # #   redirect_to item_path(@item.id)
    # # end

    # @cart_items = current_customer.cart_items.all
    # @cart_items.each do |cart_item|
    #   if cart_item.item_id == @cart_item.item_id
    #     new_amount = cart_item.amount + @cart_item.amount.to_i
    #     # @cart_item（追加するアイテム）のamountがnilだった場合、.to_iでゼロを返してエラー回避
    #     cart_item.update_attribute(:amount,new_amount)
    #     @cart_item.delete
    #   end
    # end
    # @cart_item.save
    # flash[:notice]="商品を追加しました"
    # redirect_to cart_items_path
  end

  # カート内商品データ更新
  def update
    @cart_item.update(cart_item_params) if @cart_item
    redirect_to cart_items_path
    # @cart_item = CartItem.find(params[:id])
    # if @cart_item.update(cart_item_params)
    #   flash[:notice]="注文個数を変更しました"
    #   redirect_to cart_items_path
    # else
    #   flash[:notice]="注文個数の変更ができませんでした"
    #   render:index
    # end
  end

  # カート内商品データ削除（1商品）
  def destroy
    @cart_item.destroy if @cart_item
    redirect_to cart_items_path
    # cart_item = CartItem.find(params[:id])
    # if cart_item.destroy
    #   flash[:notice]="商品を削除しました"
    #   redirect_to cart_items_path
    # end
  end

  # カート内商品データ削除（全て）
  def destroy_all
    if current_customer.cart_items.destroy_all
      flash[:notice]="商品をすべて削除しました"
      redirect_to cart_items_path
    end
  end
  
  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id,:amount).merge(customer_id:current_customer.id)
  end
  
  def set_cart_item
    @item = Item.find(params[:item_id])
    @cart_item = current_customer.has_in_cart(@item)
  end

end