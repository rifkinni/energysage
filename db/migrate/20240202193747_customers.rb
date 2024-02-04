class Customers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |c|
      c.string :customer_id
      c.string :first_name
      c.string :last_name
      c.string :email
      c.integer :electricity_usage_kwh
      c.boolean :old_roof
      c.string :street_address
      c.string :city
      c.string :postal_code
      c.string :state_code
      c.timestamps
    end
  end
end
