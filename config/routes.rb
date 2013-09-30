MetroPortfolio::Application.routes.draw do
 mount Ckeditor::Engine => '/ckeditor'
  
  namespace :admin do
      
      match 'login' => 'portal#login'
      match 'doLogin' => 'portal#doLogin', :as => 'doLogin'
      match '/' => 'portal#index'
      match 'logout' => 'portal#logout', :as => 'logout_admin_user'
      match 'dashboard' => 'portal#index'
      resources :users 
      match 'deactivate_user/:id' => 'users#deactivate_user', :as => 'deactivate_user'
      match 'activate_user/:id' => 'users#activate_user', :as => 'activate_user'
      
      resources :albums
      resources :gallery_images
      resources :portfolios
      resources :pages
      resources :portfolio_types
      resources :banners
      resources :strengths
      
      root :to => "portal#index"
  end
  
  
  
  match 'change_session' => 'contacts#change_session'
  match 'contact_me' => 'contact#index'
  match 'portfolio' => 'portfolio#index'
  match 'gallery' => 'gallery#index'
  match 'show_portfolio/:id' => 'portfolio#show'
  match 'submit_enquiry' => 'contact#submit_enquiry', :as => 'submit_enquiry'
  match 'contact_us_enquiry' => 'contact#change_session'
  match ':url' => 'about#index'
  
  
  match '/' => 'home#index'
  root :to => 'home#index'
end
