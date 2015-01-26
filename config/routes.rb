# -*- encoding : utf-8 -*-
NewsOnRails::Application.routes.draw do

# FELLES:
  match "/articles/list" => "articles#list", via: [:get, :post]
  resources :articles
  match "/articles/:id" => "start#view", via: [:get]

  match "/gropus/home" => "groups#home", via: [:get, :post]
  match "/groups/list" => "groups#list", via: [:get, :post]
  match "/account/logout" => "account#logout", via: [:get, :post]
  match "/lister/list" => "lister#list", via: [:get, :post]
  match "/articles/:id" => "articles#update", via: [:post]

  resources :paths
  resources :stylesheets
  resources :helps
  resources :gropus
  resources :lister

  match '/:controller(/:action(/:id))', via: [:get, :post]

  # resources :lag do
  #   collection do
  # get :id
  # end
  # end

  # resources :start do
  #   collection do
  # get :id
  # end  
  # end

   get ':lag/:id.:format' => 'lag#index'
   get ':lag/:id' => 'lag#index'
   get ':lag/view/:id' => 'start#view'
  # get ':controller/service.wsdl' => '#wsdl'
   get 'start/view/:id/:lagid' => 'start#view'



  # post 'articles/update/:id' => 'articles#update'
  # post 'articles/:id' => 'start#view'
  
  #match 'articles/' to: 'articles#index', via: [:get, :post]0


# FELLES SLUTT

  root :to => 'start#view', :id => '1'
  get ':lag.:format' => 'lag#index', :id => '10'
  get 'norhjelp' => 'start#view', :id => '13281'
  get 'finnes_ikke' => 'start#view', :id => '1'
  get 'forside' => 'start#view', :id => '1'
  get 'blimedlem' => 'start#view', :id => '312'

  get ':lag' => 'lag#index', :id => '10'
#  get '' => 'Sentralt#10'
#  get 'hotest' => 'lag#index', :lag => 'Sentralt', :id => '1'
  get 'hotest' => 'start#view', :id => '1'
  #  get ':lag/:id/:page' => 'lag#index', :constraints => { :page => /\d+/, :id => /\d+/ }, :lag => , :page => , :id =>
   get '*path' => 'application#rescue_404'
end

