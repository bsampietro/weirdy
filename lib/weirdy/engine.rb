module Weirdy
  class Engine < ::Rails::Engine
    isolate_namespace Weirdy
    # doesn't work
    #config.active_record.whitelist_attributes = false
  end
end
