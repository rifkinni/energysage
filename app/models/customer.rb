require 'securerandom'

class Customer < ApplicationRecord
  self.primary_key = "customer_id"

  attribute :customer_id, default: -> { SecureRandom.uuid }
  attribute :electricity_usage_kwh, :integer, default: 0

  validates :customer_id, :first_name, :last_name, :email, :street_address, :city, :state_code, :postal_code, presence: true
  validates :postal_code, format: { with: /\A[0-9]{5}\z/}

  # email uniqueness is enforced in the controller, but this is an extra safety to prevent race conditions
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def to_json(options = {})
    {
      :id => customer_id,
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :electricity_usage_kwh => electricity_usage_kwh,
      :old_roof => old_roof,
      :property_address => {
        :street => street_address,
        :city => city,
        :postal_code => postal_code,
        :state_code => state_code
      }
    }.to_json
  end
end
