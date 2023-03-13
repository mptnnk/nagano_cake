class Order < ApplicationRecord
  enum payment_method:{
    credit:0,
    bank:1,
  }
  
  enum status:{
    payment_waiting:0,
    payment_confirmation:1,
    in_production:2,
    preparing_deliver:3,
    deliverd:4,
  }
end
