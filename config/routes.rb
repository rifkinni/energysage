Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/'
end
