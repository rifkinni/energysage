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
end
