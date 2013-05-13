TelescopeLogin::Application.routes.draw do
  namespace :admin do
    resources :users
  end
  mount Masq::Engine => '/'
end
