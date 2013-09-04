class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Exception do |exception|
    weirdy_log_exception(exception)
    raise exception
  end
  
  def current_user
    User.first
  end
end
