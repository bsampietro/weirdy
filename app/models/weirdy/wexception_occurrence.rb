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
      
    attr_accessible :wexception, :backtrace, :backtrace_hash, :happened_at, :data
  end
end