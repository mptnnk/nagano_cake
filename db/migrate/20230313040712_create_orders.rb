class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      
      t.integer :customer_id
      t.integer :shipping_cost
      t.integer :total_payment
      t.integer :payment_method
      # enumで管理
      t.string :postal_code
      t.string :address
      t.string :name
      t.integer :status
      # enumで管理
      

      t.timestamps
    end
  end
end
