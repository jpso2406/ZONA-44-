class HomeController < ApplicationController
    before_action :authenticate_usuario!
    def welcome 
    end
end
    