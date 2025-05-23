Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: 'dashboards#index'

  get "dashboards/index"

  get "auth/forgot-password", to: 'auth#forgot_password'
  get "auth/lock-screen", to: 'auth#lockscreen'
  get "auth/login", to: 'auth#login'
  get "auth/login-2", to: 'auth#login_two_columns'
  get "auth/register", to: 'auth#register'

  get "error/404", to: 'error#error_404'
  get "error/500", to: 'error#error_500'

  get "pages/empty", to: 'pages#empty_page'
  get "layouts/boxed", to: 'layouts_eg#boxed'
  get "layouts/canvas-menu", to: 'layouts_eg#canvas_menu'
  get "layouts/collapse-sidebar", to: 'layouts_eg#collapse_sidebar'
  get "layouts/dark-mode", to: 'layouts_eg#dark_mode'
  get "layouts/footer-fixed", to: 'layouts_eg#footer_fixed'
  get "layouts/sidebar-fixed", to: 'layouts_eg#sidebar_fixed'
  get "layouts/topbar-fixed", to: 'layouts_eg#topbar_fixed'
  get "layouts/topbar-fullwidth", to: 'layouts_eg#topbar_fullwidth'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
