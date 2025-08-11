Rails.application.routes.draw do
  # API sin traducción
  namespace :api do
    namespace :v1 do
      resources :productos, only: [:index]
    end
  end

  # Rutas públicas traducibles
  localized do
    post "/carrito", to: "carrito#agregar", as: "carrito"
    post "agregar_al_carrito/:producto_id", to: "carrito#agregar", as: "agregar_al_carrito"
    post "reducir_del_carrito/:id", to: "carrito#reducir", as: "reducir_del_carrito"
    delete "eliminar_del_carrito/:id", to: "carrito#eliminar", as: "eliminar_del_carrito"

    get "mostrar_carrito", to: "carrito#mostrar", as: "mostrar_carrito"

    # Ruta para ver productos por grupo (con slug SEO)
    get "menus/:id-:slug", to: "menus#grupo", as: "menu_grupo"

    # Ruta pública para ver todos los grupos en el menú
    get "menu", to: "menus#general", as: "menu_general"

    resources :grupo, only: [:index, :show] do
      resources :producto, only: [:index, :show], module: :grupo
    end

    get "bienvenidos", to: "home#index"
    root to: "home#index"

    devise_for :admins, skip: [:registrations]
    get "admin/dashboard", to: "admin#dashboard", as: "admin_dashboard"

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
  end
end
