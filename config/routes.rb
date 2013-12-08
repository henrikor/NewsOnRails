# -*- encoding : utf-8 -*-
NewsOnRails::Application.routes.draw do

  resources :stylesheets
  resources :helps
  match '/:controller(/:action(/:id))'
  resources :lag do
    collection do
  get :id
  end
  
  
  end

  resources :start do
    collection do
  get :id
  end
  
  
  end

  root :to => 'start#view', :id => '1'
  match ':lag/:id.:format' => 'lag#index'
  match ':lag.:format' => 'lag#index', :id => '10'
  match 'blimedlem' => 'start#view', :id => '312'
  match 'finnes_ikke' => 'start#view', :id => '1'
  match 'drammen' => 'start#view', :lag => 'sentralt', :id => '5'
  match 'fredrikstad' => 'start#view', :lag => 'sentralt', :id => '5'
  match 'trondheim' => 'start#view', :lag => 'trondheim-lag', :id => '5'
  match 'romerike' => 'start#view', :lag => 'romerike-lag', :id => '5'
  match ':lag/view/:id' => 'start#view'
  match ':controller/service.wsdl' => '#wsdl'
  match ':lag' => 'lag#index', :id => '10'
  match 'start/view/:id/:lagid' => 'start#view'
  match '' => 'start#view', :id => '1'
#  match ':lag/:id/:page' => 'lag#index', :constraints => { :page => /\d+/, :id => /\d+/ }, :lag => , :page => , :id => 
  match '*path' => 'application#rescue_404'
end
