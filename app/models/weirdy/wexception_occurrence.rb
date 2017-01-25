module Weirdy
  class WexceptionOccurrence < ActiveRecord::Base
    belongs_to :wexception

    serialize :backtrace
    serialize :data
  end
end
