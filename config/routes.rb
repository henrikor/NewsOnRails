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



  root :to => 'start#view', :id => '10522'




#  match '/Sentralt/:id' => 'lag#index', :lag => 'sentralt-organisasjon' # Kun for sos-rasisme.no
  match ':lag/:id.:format' => 'lag#index'
  match ':lag/:id' => 'lag#index'
  match ':lag.:format' => 'lag#index', :id => '10'
  match 'norhjelp' => 'start#view', :id => '13281'
  match 'finnes_ikke' => 'start#view', :id => '10522'
  match 'forside' => 'start#view', :id => '10'


  match ':lag/view/:id' => 'start#view'
  match ':controller/service.wsdl' => '#wsdl'
  match ':lag' => 'lag#index', :id => '10'
  match 'start/view/:id/:lagid' => 'start#view'
#  match '' => 'Sentralt#10'
#  match 'hotest' => 'lag#index', :lag => 'Sentralt', :id => '10'
#  match ':lag/:id/:page' => 'lag#index', :constraints => { :page => /\d+/, :id => /\d+/ }, :lag => , :page => , :id =>
  match '*path' => 'application#rescue_404'
end
