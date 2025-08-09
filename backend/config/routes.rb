Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :productos, only: [:index]
    end
  end

    post "/carrito", to: "carrito#agregar", as: "carrito"
    post "agregar_al_carrito/:producto_id", to: "carrito#agregar", as: "agregar_al_carrito"
    post "reducir_del_carrito/:id", to: "carrito#reducir", as: "reducir_del_carrito"
    delete "eliminar_del_carrito/:id", to: "carrito#eliminar", as: "eliminar_del_carrito"

    get "mostrar_carrito", to: "carrito#mostrar", as: "mostrar_carrito"

    # Ruta para ver productos por grupo (con slug SEO)
    get "menus/:id-:slug", to: "menus#grupo", as: "menu_grupo"

    # Ruta pública para ver todos los grupos en el menú
    get "menu", to: "menus#general", as: "menu_general"

    resources :grupo, only: [ :index, :show ] do
      resources :producto, only: [ :index, :show ], module: :grupo
    end

    get "bienvenidos", to: "home#index"
    get "contacto", to: "home#contacto"
    root to: "home#index"
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.

    devise_for :admins, skip: [ :registrations ]
    # get "admin/dashboard", to: "admin#dashboard", as: "admin_dashboard"


    resources :admin, only: [:index] 
    namespace :admin do
      resources :pizzas
      resources :promociones

    end

    # Recursos del panel de administración
    resources :grupos
    resources :productos
    resources :pizzas
    resources :pizza_tradicionales
    resources :pizza_especiales
    resources :pizza_combinadas
    resources :tamano_pizzas
    resources :borde_quesos

    # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
    # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    # Defines the root path route ("/")
    # root "posts#index"

    namespace :dashboard do
      root to: "dashboard#index"
      resources :promociones, only: [:index, :new, :create, :destroy]
      resources :productos, only: [:index, :new, :create, :edit, :update, :destroy]
    end
end