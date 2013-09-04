class HomeController < ApplicationController
  def index
    methods = (1..6).to_a.map {|i| "met#{i}"}
    rand(2) == 1 ?
      User.new.send(methods.sample) :
      send(methods.sample)
  end
  
  def met1
    met2
  end
  
  def met2
    raise "met 2 is not working right"
  end
  
  def met3
    cccalling.non.existent
  end
  
  def met4
    JSON.parse("not json")
  end
  
  def met5
    met4
  end
  
  def met6
    Timeout::timeout(5) {
      sleep(6)
    }
  end
end
