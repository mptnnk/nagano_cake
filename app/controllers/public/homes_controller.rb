class Public::HomesController < ApplicationController
  def top
    @items = Item.where(is_active: true).limit(4).order("created_at DESC")
    @genres = Genre.all
  end

  def about
  end
end
