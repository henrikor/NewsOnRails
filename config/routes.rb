# -*- encoding : utf-8 -*-
NewsOnRails::Application.routes.draw do

  resources :stylesheets
  resources :helps
  get '/:controller(/:action(/:id))'
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



  root :to => 'start#view', :id => '5'




#  match '/Sentralt/:id' => 'lag#index', :lag => 'sentralt-organisasjon' # Kun for sos-rasisme.no
  get ':lag/:id.:format' => 'lag#index'
  get ':lag/:id' => 'lag#index'
  get ':lag.:format' => 'lag#index', :id => '10'
  get 'norhjelp' => 'start#view', :id => '13281'
  get 'finnes_ikke' => 'start#view', :id => '5'
  get 'forside' => 'start#view', :id => '5'


  get ':lag/view/:id' => 'start#view'
  get ':controller/service.wsdl' => '#wsdl'
  get ':lag' => 'lag#index', :id => '10'
  get 'start/view/:id/:lagid' => 'start#view'
#  get '' => 'Sentralt#10'
#  get 'hotest' => 'lag#index', :lag => 'Sentralt', :id => '10'
#  get ':lag/:id/:page' => 'lag#index', :constraints => { :page => /\d+/, :id => /\d+/ }, :lag => , :page => , :id =>
  get '*path' => 'application#rescue_404'
end
