Rails.application.routes.draw do
  resources :departmentassignments
  resources :departments

  resources :runlists do
    collection do
      get :activerunlist
      get :checkboxsubmit
      get :changedepartment
      post :teststream
    end
  end



  get "millinginvs/:id/checkout", to: "millinginvs#checkout", as: :millingcheckout
  get "millinginvs/:id/checkin", to: "millinginvs#checkin", as: :millingcheckin
  post "millinginvs/:id", to: "millinginvs#status", as: :millingstatus
  get "millinginvs/belowmin", to: "millinginvs#belowmin", as: :millingbelowmin

  get "turninginvs/:id/checkout", to: "turninginvs#checkout", as: :turningcheckout
  get "turninginvs/:id/checkin", to: "turninginvs#checkin", as: :turningcheckin
  post "turninginvs/:id", to: "turninginvs#status", as: :turningstatus
  get "turninginvs/belowmin", to: "turninginvs#belowmin", as: :turningbelowmin
  resources :histories
  resources :turninginvs
  resources :millinginvs
  resources :runlists
  resources :employees


  #patch "turninginvs/:id/checkout", to: "turninginvs#update"
  # get 'home/index'  #commented out bc we set the root page on the next line. 
  get 'home/about'
  root 'home#index' #notice the "#" symbol.  sets main homepage upon typing in url. 


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
