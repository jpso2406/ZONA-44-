Rails.application.routes.draw do
  # --------------------
  # Root
  # --------------------
  root to: "home#index"

  # --------------------
  # Devise
  # --------------------
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_for :admins

  # --------------------
  # API
  # --------------------
  namespace :api do
    namespace :v1 do
      get "/user_orders", to: "user_orders#index"
      # Endpoints para admin (ver y actualizar pedidos de todos los usuarios)
      get "/admin/orders", to: "admin_orders#index"
      patch "/admin/orders/:id", to: "admin_orders#update"
      get "/admin/dashboard", to: "admin_dashboard#index"
  resources :productos, except: [ :new, :edit, :show ]
  resources :promociones, except: [ :new, :edit ]
      resources :grupos, except: [ :new, :edit, :show ]
      resources :orders, only: [ :create, :show ] do
        post :pay, on: :member
      end

      # Endpoints de autenticación y perfil para Flutter
      post "/register", to: "auth#register"
      post "/login", to: "auth#login"
      get "/profile", to: "auth#profile"
      put "/profile", to: "auth#update"
      delete "/profile", to: "auth#destroy"
      post "auth/google", to: "auth#google"
    end
  end

  # --------------------
  # Rutas públicas traducibles
  # --------------------
  localized do
    # Carrito
    post "/carrito", to: "carrito#agregar", as: "carrito"
    post "agregar_al_carrito/:producto_id", to: "carrito#agregar", as: "agregar_al_carrito"
    post "reducir_del_carrito/:id", to: "carrito#reducir", as: "reducir_del_carrito"
    delete "eliminar_del_carrito/:id", to: "carrito#eliminar", as: "eliminar_del_carrito"
    get "mostrar_carrito", to: "carrito#mostrar", as: "mostrar_carrito"

    # Checkout
    resources :checkout, only: [ :new, :create, :show ] do
      member do
        get :payment
        post :process_payment
        get :payment_success
        get :payment_failed
      end
    end

    # Home
    get "bienvenidos", to: "home#index"
    get "contacto", to: "home#contacto"

    # Menú público
    get "menu", to: "menus#general", as: "menu_general"
    get "menus/:id-:slug", to: "menus#grupo", as: "menu_grupo"

    # Grupos públicos
    get "/grupo", to: "grupo#index", as: "grupo_index"    # <-- helper exacto
    resources :grupo, only: [ :show ] do
      resources :producto, only: [ :index, :show ], module: :grupo
    end

  # Perfil de usuario
  get "perfil", to: "users#show", as: "perfil"
  resources :users, only: [ :show ]
    # Recursos públicos
    get "/productos/:id", to: "productos#show", as: "producto"
    resources :grupos, only: [ :index, :show ]
    resources :productos, only: [ :index, :show ]
  end

  # --------------------
  # Dashboard Admin
  # --------------------
  namespace :dashboard do
    root to: "dashboard#index", as: :root

    resources :grupos
    resources :promociones
    resources :productos

    resources :users, only: [ :index, :show ]
    resources :orders do
      member do
        patch :confirm_cash_payment
        patch :cancel_order
      end
    end
  end
  # --------------------
  # Inteligencia Artificial
  # --------------------
  get  "ia/reporte",   to: "ia#reporte"
  post "ia/consultar", to: "ia#consultar"
end
