module Weirdy
  class ApplicationController < Weirdy::Config.use_main_app_controller ? ::ApplicationController : ActionController::Base
    before_filter :auth
    
    private
    
    def auth
      if Weirdy::Config.auth.is_a? Proc
        if !Weirdy::Config.auth.call(self)
          render :nothing => true
        end
      elsif Weirdy::Config.auth.is_a? String
        username, password = Weirdy::Config.auth.split('/')
        authenticate_or_request_with_http_basic("Weirdy") do |typed_username, typed_password|
          typed_username == username && typed_password == password
        end
      end
    end
  end
end
