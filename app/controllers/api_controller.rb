class ApiController < ApplicationController
  def fetch
    customer = Customer.find_by(customer_id: params[:customer_id])
    customer.nil? ? render_404 : (render json: customer, status: :ok, message: "Customer Found")
  end

  private

  def render_404
    render status: :not_found, body: "Customer Not Found"
  end
end
