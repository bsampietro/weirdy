module Weirdy
  class WexceptionOccurrence < ActiveRecord::Base
    belongs_to :wexception
    
    serialize :backtrace
    serialize :data
      
    attr_accessible :wexception, :message, :backtrace, :happened_at, :data
  end
end
