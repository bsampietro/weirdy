class HomeController < ApplicationController
  def index
    User.first.admin?
  end
end
