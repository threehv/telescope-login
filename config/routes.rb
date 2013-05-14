TelescopeLogin::Application.routes.draw do
  namespace :admin do
    resources :users do
      member do
        get :remove
      end
    end
  end
  mount Masq::Engine => '/'
end
