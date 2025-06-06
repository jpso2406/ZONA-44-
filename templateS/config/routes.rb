  Rails.application.routes.draw do
    # Página principal
    root to: 'home#bienvenida'
    get 'bienvenidos', to: 'home#bienvenida'
    get 'menu', to: 'home#menu'

    # Autenticación
    get 'auth/lock-screen',     to: 'auth#lockscreen'
    get 'auth/login',           to: 'auth#login'
    get 'auth/login-2',         to: 'auth#login_two_columns'
    get 'auth/forgot-password', to: 'auth#forgot_password'
    get 'auth/register',        to: 'auth#register'



    # Páginas de error
    get 'error/404', to: 'error#error_404'
    get 'error/500', to: 'error#error_500'

    # Página vacía
    get 'pages/empty', to: 'pages#empty_page'

    # Layouts
    resources :layouts_eg, only: [] do
      collection do
        get :boxed
        get :canvas_menu
        get :collapse_sidebar
        get :dark_mode
        get :footer_fixed
        get :sidebar_fixed
        get :topbar_fixed
        get :topbar_fullwidth
      end
    end

    # Área de usuarios
    namespace :users do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      get 'auth/login', to: 'auth#login', as: 'auth'
      get 'login', to: 'devise/sessions#new'
    end

    # Devise
    devise_for :users

    # Otros recursos
    get 'up' => 'rails/health#show', as: :rails_health_check
    resources :grupos
    resources :productos
    resources :layouts_eg
  end
