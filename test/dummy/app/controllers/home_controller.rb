class HomeController < ApplicationController
  def index
    session['hola'] = "hola"
    raise "workkssss!!4"
  end
end
