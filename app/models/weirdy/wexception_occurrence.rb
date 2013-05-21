module Weirdy
  class WexceptionOccurrence < ActiveRecord::Base
    belongs_to :wexception
  
    serialize :backtrace
    serialize :data  
      #  url
      #  method
      #  session
      #  cookies
      #  params
      #  remote_ip
      #  xhr?
  end
end
