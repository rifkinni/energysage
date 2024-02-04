class ApiController < ApplicationController
  def fetch
    customer = Customer.find_by(customer_id: params[:customer_id])
    customer.nil? ? render_404 : (render json: customer, status: :ok, message: "Customer Found")
  end

  def create
    #check for email collisions
    existing = Customer.find_by(email: params[:email])
    render_409 && return if existing.present? && existing.customer_id != params[:customer_id]

    customer = Customer.create(customer_param_map(params))
    # check that the customer was saved successfully
    customer.valid? ? (render json: customer, status: :ok) : render_400
  end

  private

  def customer_param_map(params)
    params[:property_address] ||= {}

    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      old_roof: params[:old_roof],
      electricity_usage_kwh: params[:electricity_usage_kwh],
      street_address: params[:property_address][:street],
      city: params[:property_address][:city],
      postal_code: params[:property_address][:postal_code],
      state_code: params[:property_address][:state_code]
    }.filter { |_, v| v.present? }
  end

  def render_400
    render status: :bad_request, body: "Missing Required Information"
  end

  def render_404
    render status: :not_found, body: "Customer Not Found"
  end

  def render_409
    render status: 409, body: "Email Already Taken"
  end
end
