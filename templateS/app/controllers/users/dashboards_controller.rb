module Users
    class DashboardsController < ApplicationController       
        before_action :authenticate_user!
        def index
            # lógica para el dashboard del usuario
        end
    end
end
