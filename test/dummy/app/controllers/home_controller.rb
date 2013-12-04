class HomeController < ApplicationController
  def index
    session["h"] = "hola"
    session["h2"] = "hola2"
    cookies["hk"] = "peque"
    cookies["hk2"] = "pole"
    methods = (1..7).to_a.map {|i| "met#{i}"}
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

  def met7
    raise "Really big exception message. This is a really big message and we want to truncate it because 
      is really annoying to have a long long long message in a mail subject"
  end
end
