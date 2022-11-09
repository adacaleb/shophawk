Rails.application.routes.draw do
  resources :histories
  resources :turninginvs
  get "turninginvs/:id/checkout", to: "turninginvs#checkout", as: :turningcheckout
  #patch "turninginvs/:id/checkout", to: "turninginvs#update"
  # get 'home/index'  #commented out bc we set the root page on the next line. 
  get 'home/about'
  root 'home#index' #notice the "#" symbol.  sets main homepage upon typing in url. 


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
