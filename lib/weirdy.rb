require "will_paginate"

require "weirdy/engine"
require "weirdy/config"
require "weirdy/controller_methods"

module Weirdy
  # Log your application exception.
  def self.log_exception(exception, data = {})
    begin
      Wexception.wcreate(exception, data)
    rescue Exception => e
      log_weirdy_error(e)
      return nil
    end
  end
  
  # Public method to send notification email.
  def self.notify_exception(wexception)
    begin
      Notifier.exception(wexception).deliver
    rescue Exception => e
      log_weirdy_error(e)
      return nil
    end
  end
  
  def self.log_weirdy_error(exception)
    Rails.logger.error %Q{Weirdy Gem error: #{exception.class.name} - "#{exception.message}"\n#{exception.backtrace.to_a[0..10].map {|line| "  " + line}.join("\n")}\n\n}
  end
  private_class_method :log_weirdy_error
end

ActionController::Base.send(:include, Weirdy::ControllerMethods)