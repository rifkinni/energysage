# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

class CustomerTest < Minitest::Test
  def test_customer_serializes_correctly
    # Customer#new creates an instance of the class without persisting to the database
    email = unique_email
    customer = Customer.new(
      customer_id: "my-test-id",
      first_name: "Jane",
      last_name: "Doe",
      email: email,
      old_roof: false,
      street_address: "100 Beacon St",
      city: "Boston",
      postal_code: "02161",
      state_code: "MA")

    expected = "{\"id\":\"my-test-id\",\"first_name\":\"Jane\",\"last_name\":\"Doe\",\"email\":\"#{email}\",\"electricity_usage_kwh\":0,\"old_roof\":false,\"property_address\":{\"street\":\"100 Beacon St\",\"city\":\"Boston\",\"postal_code\":\"02161\",\"state_code\":\"MA\"}}"

    assert customer.valid?
    assert_equal expected, customer.to_json.to_str
  end

  def test_errors_when_required_fields_are_nil
    error = assert_raises(ActiveRecord::RecordInvalid) {
      Customer.create!(
        customer_id: "my-test-id-1",
        first_name: nil,
        last_name: "Doe",
        email: unique_email,
        old_roof: false,
        street_address: "100 Beacon Street",
        city: "Boston",
        postal_code: "02161",
        state_code: "MA")
    }
    assert_equal "Validation failed: First name can't be blank", error.message
  end

  def test_errors_when_required_fields_are_not_present
    error = assert_raises(ActiveRecord::RecordInvalid) {
      Customer.create!(
        customer_id: "my-test-id-2",
        first_name: "Jane",
        last_name: "Doe",
        email: unique_email,
        city: "Boston",
        postal_code: "02161",
        state_code: "MA")
    }
    assert_equal "Validation failed: Street address can't be blank", error.message
  end

  def test_errors_for_invalid_email_format
    error = assert_raises(ActiveRecord::RecordInvalid) {
        Customer.create!(
          email: "not-an-email",
          customer_id: "my-test-id",
          first_name: "Jane",
          last_name: "Doe",
          old_roof: false,
          street_address: "100 Beacon St",
          city: "Boston",
          postal_code: "02161",
          state_code: "MA")
    }
    assert_equal "Validation failed: Email is invalid", error.message
  end

  def test_errors_for_duplicate_email
    error = assert_raises(ActiveRecord::RecordInvalid) {
      2.times do
        Customer.create!(
          email: "jdoe@example.com",
          customer_id: "my-test-id",
          first_name: "Jane",
          last_name: "Doe",
          old_roof: false,
          street_address: "100 Beacon St",
          city: "Boston",
          postal_code: "02161",
          state_code: "MA")
      end
    }
    assert_equal "Validation failed: Email has already been taken", error.message
  end

  def test_errors_for_invalid_zip
    error = assert_raises(ActiveRecord::RecordInvalid) {
      Customer.create!(
        postal_code: "0216",
        customer_id: "my-test-id",
        first_name: "Jane",
        last_name: "Doe",
        email: unique_email,
        old_roof: false,
        street_address: "100 Beacon St",
        city: "Boston",
        state_code: "MA")
    }
    assert_equal "Validation failed: Postal code is invalid", error.message
  end

  def test_uuid_automatically_generated
    customer = Customer.new(
      first_name: "Jane",
      last_name: "Doe",
      email: "jdoe@example.com",
      old_roof: false,
      street_address: "100 Beacon St",
      city: "Boston",
      postal_code: "02161",
      state_code: "MA")
    assert_match /[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}/, customer.customer_id
  end
end
