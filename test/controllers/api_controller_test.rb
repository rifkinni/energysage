require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  # load test data into the database and parse the example json
  # there is no convenient way to run this only once with minitest (see https://stackoverflow.com/a/39110709)
  # consider migrating from minitest to rspec
  def setup
    Rails.application.load_seed
    @user_json = JSON.parse(File.read('./test/fixtures/files/test_user_response.json'))
    super
  end

  test "successfully fetches a user" do
    get '/customer/088242aa-1805-450a-a4ea-f1f392b330f4'
    assert_response :ok

    expected = @user_json.merge({"id" => "088242aa-1805-450a-a4ea-f1f392b330f4"})
    actual = JSON.parse(response.body)
    assert_equal expected, actual
  end

  test "returns 404 when fetching a user if account is not found" do
    get '/customer/fake-user-id'
    assert_response :not_found
  end

  test "successfully creates a user" do
    expected = @user_json.merge({"email" => unique_email })

    post '/customer', params: expected
    assert_response :ok

    actual = JSON.parse(response.body).except("id") # we don't know the random uuid, just remove it
    assert_equal expected, actual
  end

  test "returns a 409 when creating a user with an email collision" do
    post '/customer', params: @user_json
    assert_response 409
  end

  test "returns a 400 when creating a user if required data is missing" do
    post '/customer', params: @user_json.except("email")
    assert_response 400
  end

  test "defaults optional data when creating a user" do
    post '/customer', params: @user_json.merge({"email" => unique_email }).except("electricity_usage_kwh")
    assert_response :ok

    actual = JSON.parse(response.body)
    assert_equal 0, actual["electricity_usage_kwh"]
  end

  test "successfully updates customer data" do
    patch '/customer/088242aa-1805-450a-a4ea-f1f392b330f4', params: {first_name: "Nicole"}
    assert_response :ok

    expected = @user_json.merge({"first_name" => "Nicole", "id" => "088242aa-1805-450a-a4ea-f1f392b330f4" })
    actual = JSON.parse(response.body)
    assert_equal expected, actual
  end

  test "returns a 404 when updating a user if the id is not found" do
    patch '/customer/fake-user-id', params: @user_json
    assert_response :not_found
  end

  test "returns a 409 when updating a user with an email collision" do
    #create a new test user with a unique email
    Customer.create(
      email: "collision.test@example.com",
      customer_id: "my-test-id",
      first_name: "Jane",
      last_name: "Doe",
      old_roof: false,
      street_address: "100 Beacon St",
      city: "Boston",
      postal_code: "02161",
      state_code: "MA"
    )

    # update our default test user with the same email as the customer we just created
    patch '/customer/088242aa-1805-450a-a4ea-f1f392b330f4', params: {"email" => "collision.test@example.com"}
    assert_response 409
  end

  test "ignores email collision if email matches existing customer_id" do
    patch '/customer/088242aa-1805-450a-a4ea-f1f392b330f4', params: @user_json
    assert_response :ok

    expected = @user_json.merge("id" => "088242aa-1805-450a-a4ea-f1f392b330f4" )
    actual = JSON.parse(response.body)
    assert_equal expected, actual
  end
end
