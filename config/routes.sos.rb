# -*- encoding : utf-8 -*-
NewsOnRails::Application.routes.draw do

  # resources :stylesheets
  # resources :helps
  # match '/:controller(/:action(/:id))'
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

  # resources :menu_elements

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



  root :to => 'start#view', :id => '13236'

  get '/Sentralt/:id' => 'lag#index', :lag => 'sentralt-organisasjon'
  get ':lag/:id.:format' => 'lag#index'
  get ':lag.:format' => 'lag#index', :id => '10'
  get 'norhjelp' => 'start#view', :id => '13281'
  get 'finnes_ikke' => 'start#view', :id => '13236'
  get 'sprak' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13714'
  get 'Lm2010/valg' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13386'
  get 'LM2010/valg' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13386'
  get 'lm2010/valg' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13386'
  get 'lm2010/registrering' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13378'
  get 'LM2010/registrering' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13378'
  get 'Lm2010/registrering' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13378'
  get 'lm2010/innkalling' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13385'
  get 'LM2010/innkalling' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13385'
  get 'Lm2010/innkalling' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13385'
  get 'lm2010/annonse' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13376'
  get 'LM2010/annonse' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13376'
  get 'Lm2010/annonse' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13376'
  get 'Lm2010/forslag' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13384'
  get 'LM2010/forslag' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13384'
  get 'lm2010/forslag' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13384'
  get 'Lm2010' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13362'
  get 'LM2010' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13362'
  get 'lm2010' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13362'
  get 'prosessen' => 'start#view', :lag => 'sentralt', :id => '13502'
  get 'papir' => 'start#view', :lag => 'sentralt', :id => '13880'
  get 'button' => 'start#view', :lag => 'sentralt', :id => '14000'
  get 'buttons' => 'start#view', :lag => 'sentralt', :id => '14000'
  get 'vest-agder' => 'start#view', :lag => 'vest-agder', :id => '13730'
  get 'forside' => 'start#view', :id => '13236'
  get 'ressurser' => 'start#view', :lag => 'sentralt-ressurser', :id => '13258'
  get 'organisasjon' => 'start#view', :lag => 'sentralt-organisasjon', :id => '13262'
  get 'nyheter' => 'start#view', :lag => 'sentralt-nyheter', :id => '13263'
  get '17mfa' => 'start#view', :lag => '17mai', :id => '10447'
  get '17mai' => 'start#view', :lag => '17mai', :id => '10447'
  get 'kurs' => 'start#view', :lag => 'sentralt-ressurser', :id => '13423'
  get 'lister' => 'lister#list'
  get 'ashok' => 'lag#index', :lag => 'Lorenskog', :id => '154'
  get 'anu' => 'start#view', :lag => 'anu-kokebok', :id => '12052'
  get 'abbasfozia' => 'start#view', :lag => 'abbasfozia-lag', :id => '12794'
  get 'kirkeasyl' => 'start#view', :lag => 'Sentralt', :id => '13012'
  get 'antirasisten' => 'start#view', :lag => 'Sentralt-nyheter', :id => '13541'
  get 'Antirasisten' => 'start#view', :lag => 'Sentralt-nyheter', :id => '13541'
  get 'AntirasisteN' => 'start#view', :lag => 'Sentralt-nyheter', :id => '13541'
  get 'krystallnatta/markeringer' => 'lag#index', :lag => 'Sentralt', :id => '178'
  get 'valg' => 'lag#index', :lag => 'Sentralt', :id => '77'
  get 'antinazi' => 'lag#index', :lag => 'Sentralt', :id => '29'
  get 'balforbenjamin' => 'lag#index', :lag => 'Sentralt', :id => '130'
  get 'baalforbenjamin' => 'lag#index', :lag => 'Sentralt', :id => '130'
  get 'bfb' => 'lag#index', :lag => 'Sentralt', :id => '130'
  get 'sultestreik' => 'lag#index', :lag => 'Sentralt', :id => '155'
  get 'muf' => 'lag#index', :lag => 'Sentralt', :id => '100'
  get 'asylmarsj' => 'lag#index', :lag => 'Sentralt', :id => '195'
  get 'obiora' => 'lag#index', :lag => 'Sentralt', :id => '196'
  get 'lag' => 'lag#index', :lag => 'Sentralt', :id => '166'
  get 'anfal/halabja' => 'start#view', :id => '9984'
  get 'adae' => 'start#view', :id => '11253'
  get 'bliaktiv' => 'start#view', :id => '9878'
  get 'sudoku' => 'start#view', :id => '10075'
  get 'Krystallnatta' => 'start#view', :lag => 'krystallnatta', :id => '12949'
  get 'krystallnatta' => 'start#view', :lag => 'krystallnatta', :id => '12949'
  get 'johndee' => 'start#view', :lag => 'krystallnatta', :id => '10054'
  get 'llk' => 'start#view', :id => '10694'
  get 'vervingen' => 'start#view', :id => '9841'
  get 'verving' => 'start#view', :id => '9841'
  get 'blimedlem' => 'start#view', :id => '9539'
  get 'markeringsdager' => 'start#view', :id => '9563'
  get 'materiell' => 'start#view', :id => '12441'
  get 'pekere' => 'start#view', :id => '9554'
  get 'salem' => 'start#view', :id => '10078'
  get 'lorenskog/kjennfestival' => 'start#view', :lag => 'Lorenskog', :id => '9568'
  get 'jakkemerker' => 'start#view', :id => '9599'
  get 'skoler' => 'start#view', :id => '9599'
  get 'skole' => 'start#view', :id => '9599'
  get '4omdagen' => 'start#view', :id => '9691'
  get '8mars' => 'start#view', :id => '9693'
  get 'annonser' => 'start#view', :id => '9694'
  get 'od2007' => 'start#view', :id => '9803'
  get 'utfordre' => 'start#view', :id => '9902'
  get 'fakler' => 'start#view', :id => '9985'
  get 'fakkel' => 'start#view', :id => '9985'
  get 'håndfakkel' => 'start#view', :id => '9985'
  get 'faklar' => 'start#view', :id => '9985'
  get 'lm2008' => 'start#view', :id => '11489'
  get 'valgkomite' => 'start#view', :id => '11489'
  get ':lag/view/:id' => 'start#view'
  get 'rk' => 'lag#index', :id => '184'
#  get ':controller/service.wsdl' => '#wsdl'
  get ':lag' => 'lag#index', :id => '10'
  get 'start/view/:id/:lagid' => 'start#view'
  get '' => 'lag#index', :lag => 'Sentralt', :id => '10'

end
