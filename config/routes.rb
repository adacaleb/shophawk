Rails.application.routes.draw do

  
  resources :material_matquotes
  resources :matquotes
  get "materials/newOrder", to: "materials#newOrder", as: :newOrder
  resources :materials do
    collection do 
      get :matsizes, defaults: { format: :turbo_stream }
      get :matdata, defaults: { format: :turbo_stream }
    end
  end

  

  resources :stats do
    collection do 
      get :openinv, defaults: { format: :turbo_stream }
    end
  end
  resources :assignments
  resources :departments

  resources :runlists do
    collection do
      get :activerunlist, defaults: { format: :turbo_stream }
      get :checkboxsubmit, defaults: { format: :turbo_stream }
      get :changedepartment, defaults: { format: :turbo_stream } #need to have a view.turbo_stream.erb to render to work
      get :assignmentsubmit, defaults: { format: :turbo_stream } #used to call controller to save assignment selection
      get :showAssignments, defaults: { format: :turbo_stream }
      get :newassignment, defaults: { format: :turbo_stream }
      get :closestreams, defaults: { format: :turbo_stream }
      end
  end

  get "slideshows/addTimeOff", to: "slideshows#addTimeOff", as: :addTimeOff
  post "/addTimeOff", to: "slideshows#saveTimeOff", as: :saveTimeOff
  post "slideshows/viewTimeOff/:id", to: "slideshows#delTimeOff", as: :delTimeOff
  get "slideshows/timeOff", to: "slideshows#timeOff", as: :timeOff
  resources :slideshows do 
    collection do 
      get :slides, defaults: { format: :turbo_stream }
    end
  end

  namespace :charts do 
    get "total_jobs"
  end 

  
  get "runlists/:id/destroyassignment", to: "runlists#destroyassignment", as: :assignmentdestroy
  post "runlists/:id/createassignment", to: "runlists#createassignment", as: :createassignment, defaults: { format: :turbo_stream }
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


  #patch "turninginvs/:id/checkout", to: "turninginvs#update"
  # get 'home/index'  #commented out bc we set the root page on the next line. 
  get 'home/about'
  root 'home#index' #notice the "#" symbol.  sets main homepage upon typing in url. 


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
