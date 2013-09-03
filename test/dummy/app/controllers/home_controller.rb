class HomeController < ApplicationController
  def index
    shims
    #User.first.admin?
  end
  
  def shims
    raise "not compiling"
  end
end
