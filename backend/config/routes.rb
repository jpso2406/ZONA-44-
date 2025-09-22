Rails.application.routes.draw do
  # --------------------
  # Devise
  # --------------------
  devise_for :users
  devise_for :admins

  # --------------------
  # API
  # --------------------
  namespace :api do
    namespace :v1 do
      resources :productos, only: [:index]
      resources :grupos, only: [:index]
      resources :orders, only: [:create, :show] do
        post :pay, on: :member
      end
    end
  end

  # --------------------
  # Rutas públicas traducibles
  # --------------------
  localized do
    post "/carrito", to: "carrito#agregar", as: "carrito"
    post "agregar_al_carrito/:producto_id", to: "carrito#agregar", as: "agregar_al_carrito"
    post "reducir_del_carrito/:id", to: "carrito#reducir", as: "reducir_del_carrito"
    delete "eliminar_del_carrito/:id", to: "carrito#eliminar", as: "eliminar_del_carrito"
    get "mostrar_carrito", to: "carrito#mostrar", as: "mostrar_carrito"

    resources :checkout, only: [:new, :create, :show] do
      member do
        get :payment
        post :process_payment
        get :payment_success
        get :payment_failed
      end
    end

    get "menus/:id-:slug", to: "menus#grupo", as: "menu_grupo"
    get "menu", to: "menus#general", as: "menu_general"

    resources :grupo, only: [:index, :show] do
      resources :producto, only: [:index, :show], module: :grupo
    end

    get "bienvenidos", to: "home#index"
    get "contacto", to: "home#contacto"
    root to: "home#index"
  end

  # --------------------
  # Dashboard Admin
  # --------------------
  namespace :dashboard do
    # Controlador principal del panel
    root to: "dashboard#index", as: :root  # dashboard_root_path

    resources :grupos
    resources :promociones
    resources :productos
    resources :pizza
    resources :orders do
      member do
        patch :confirm_cash_payment
        patch :cancel_order
      end
    end
  end
end
