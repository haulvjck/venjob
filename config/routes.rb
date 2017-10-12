Rails.application.routes.draw do
  devise_for :users

  get 'top/index'

  resources :city, :path => "cities"
  resources :industry, :path => "industries"

  get 'job/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'
end