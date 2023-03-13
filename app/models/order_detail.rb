class OrderDetail < ApplicationRecord
  enum making_status:{
    cant_start:0,
    waiting_start:1,
    in_production:2,
    production_comp:3
  }
  
  belongs_to:orders
  belongs_to:items
end
