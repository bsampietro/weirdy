class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Exception do |exception|
    Weirdy.create_exception(exception,
      {:session => session.inspect,  
       :params => params,
       :url => request.url, 
       :method => request.method})
    raise exception
  end
  
  def current_user
    User.first
  end
end
