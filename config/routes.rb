Rails.application.routes.draw do
  devise_for :users, controllers: {
      # sessions: 'users/sessions',
      # registrations: 'users/registrations',
  }
  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'
  get 'top/index'
  get 'detail/:id' => 'job#show', as: :job_detail
  get 'favorite' => 'users/my_page#favorite', as: :favorite
  get 'history' => 'users/my_page#history', as: :history
  get 'my' => 'users/my_page#index', as: :my_page
  get 'my/info' => 'users/registrations#edit', as: :my_page_info
  post 'apply', to: 'job#apply'
  post 'confirm', to: 'job#confirm'
  post 'finish_apply', to: 'job#finish_apply'

  resources :city, :path => "cities", :only => [:index]
  resources :industry, :path => "industries", :only => [:index]

  resources :jobs do
    collection do
      get '' => 'job#index'
      get 'city/:city_id' => 'job#city', as: :city
      get 'industry/:industry_id' => 'job#industry', as: :industry
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'top#index'
end
