class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :quantity, default: 1
      t.references :products
      t.references :carts
      t.references :orders
      t.timestamps
    end
  end
end
