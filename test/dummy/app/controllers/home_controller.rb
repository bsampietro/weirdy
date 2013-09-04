class HomeController < ApplicationController
  def index
    methods = (1..6).to_a.map {|i| "met#{i}"}
    User.new.send(methods.sample)
  end
end
