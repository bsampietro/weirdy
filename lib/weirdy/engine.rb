module Weirdy
  class Engine < ::Rails::Engine
    isolate_namespace Weirdy
    #debugger
    #config.active_record.whitelist_attributes = false
    #puts config.active_record.whitelist_attributes
  end
end
