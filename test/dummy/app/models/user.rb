class User < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def admin?
    User.first.age
    #User.first.admin?
    #JSON.parse("julio")
    #Timeout::timeout(5) {
    #  sleep(6)
    #}
  end
end
