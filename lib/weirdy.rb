require "weirdy/engine"

module Weirdy
  def self.create_exception(exception, data = {})
    Wexception.wcreate(exception, data)
  end
end
