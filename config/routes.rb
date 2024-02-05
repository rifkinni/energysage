Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/'

  get '/customer/:customer_id', to: 'api#fetch'
  post '/customer', to: 'api#create'
  patch '/customer/:customer_id', to: 'api#update'
end
