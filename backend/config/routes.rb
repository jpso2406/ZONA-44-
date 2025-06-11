Rails.application.routes.draw do
  post "/carrito", to: "carrito#agregar", as: "carrito"
  get "/carrito", to: "carrito#mostrar", as: "mostrar_carrito"
  get "menus/hamburguesa", to: "menus#hamburguesa", as: "hamburguesa"
  get "menus/salchipapas", to: "menus#salchipapas", as: "salchipapas"
  get "menus/perroscalientes", to: "menus#perroscalientes", as: "perroscalientes"
  get "menus/desgrandos", to: "menus#desgranados", as: "desgranados"
  get "menus/chuzo", to: "menus#chuzo", as: "chuzo"
  get "menus/salvajada", to: "menus#salvajada", as: "salvajada"
  get "bienvenidos", to: "home#bienvenidos"
  get "menu", to: "home#menu"
  root to: "home#bienvenidos"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :admins, skip: [ :registrations ]
  get "admin/dashboard", to: "admin#dashboard", as: "admin_dashboard"
  resources :grupos
  resources :subgrupos
  resources :productos






  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
