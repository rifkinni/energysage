# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Customer.create(
  customer_id: "088242aa-1805-450a-a4ea-f1f392b330f4",
  first_name: "Alice",
  last_name: "Jones",
  email: "ajones@example.com",
  electricity_usage_kwh: 10200,
  old_roof: true,
  street_address: "100 Beacon St",
  city: "Boston",
  postal_code: "02161",
  state_code: "MA")
