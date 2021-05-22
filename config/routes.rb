Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: proc { [404, {}, ["Not found."]] }

  namespace :api do
    namespace :v1 do
      get 'balance/:user_id', to: 'wallets#balance'
    end
  end
end
