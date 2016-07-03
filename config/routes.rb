# -*- encoding : utf-8 -*-
NewsOnRails::Application.routes.draw do

<<<<<<< HEAD
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

=======
  resources :menu_elements

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

>>>>>>> d855e6e56203cc9a8c33d77148a72495b842a6e3
  match '/:controller(/:action(/:id))', via: [:get, :post]

  # resources :lag do
  #   collection do
  # get :id
  # end
  # end
<<<<<<< HEAD

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
=======

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
>>>>>>> d855e6e56203cc9a8c33d77148a72495b842a6e3


# FELLES SLUTT

  # post 'articles/update/:id' => 'articles#update'
  # post 'articles/:id' => 'start#view'
  
  #match 'articles/' to: 'articles#index', via: [:get, :post]0


# FELLES SLUTT


  #root :to => 'start#view', :id => '10522'


<<<<<<< HEAD
  root :to => 'start#view', :id => '13236'
=======
#  match '/Sentralt/:id' => 'lag#index', :lag => 'sentralt-organisasjon' # Kun for sos-rasisme.no
<<<<<<< HEAD
  match ':lag/:id.:format' => 'lag#index'
  match ':lag/:id' => 'lag#index'
  match ':lag.:format' => 'lag#index', :id => '10'
  match 'norhjelp' => 'start#view', :id => '13281'
  match 'finnes_ikke' => 'start#view', :id => '10522'
  match 'forside' => 'start#view', :id => '10'
>>>>>>> d855e6e56203cc9a8c33d77148a72495b842a6e3

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

<<<<<<< HEAD
=======
  match ':lag/view/:id' => 'start#view'
  match ':controller/service.wsdl' => '#wsdl'
  match ':lag' => 'lag#index', :id => '10'
  match 'start/view/:id/:lagid' => 'start#view'
#  match '' => 'Sentralt#10'
#  match 'hotest' => 'lag#index', :lag => 'Sentralt', :id => '10'
#  match ':lag/:id/:page' => 'lag#index', :constraints => { :page => /\d+/, :id => /\d+/ }, :lag => , :page => , :id =>
  match '*path' => 'application#rescue_404'

  match 'butikk' => 'start#view', :id => '11247'
=======

# TF:
#  root :to => 'start#view', :id => 'frontpage'
  # get ':lag.:format' => 'lag#index', :id => '10'
  # get 'norhjelp' => 'start#view', :id => '13281'
  # get 'finnes_ikke' => 'start#view', :id => '10522'
  # get 'forside' => 'start#view', :id => '5'
  # get 'butikk' => 'start#view', :id => '11247'

# NOR mal (rku):
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
>>>>>>> 328e8ee88323980e23c8d23c1f02e48899dfe598
>>>>>>> d855e6e56203cc9a8c33d77148a72495b842a6e3
end

