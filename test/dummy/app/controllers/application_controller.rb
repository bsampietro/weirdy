class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Exception do |exception|
    Weirdy.log_exception(exception,
      {:url => request.url, 
       :params => params,
       :session => session.inspect, 
       :method => request.method})
    raise exception
  end
  
  def current_user
    User.first
  end
end
