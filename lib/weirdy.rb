require "will_paginate"

require "weirdy/engine"

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
  
  module ControllerInstanceMethods
    def weirdy_log_exception(exception, data = {})
      wdata = {'URL' => request.url,
               'Params' => params,
               'Session' => session.inspect,
               'Method' => request.method,
               'User Agent' => request.env['HTTP_USER_AGENT'],
               'Referer' => request.env['HTTP_REFERER'],
               'IP' => request.remote_ip}
      wdata.merge!(data)
      Weirdy.log_exception(exception, wdata)
    end
  end
  
  class Config
    class << self
      attr_accessor :mail_recipients, 
                    :auth,
                    :mail_sender,
                    :app_name, 
                    :exceptions_per_page,
                    :shown_stack,
                    :notifier_proc, 
                    :use_main_app_controller
                    
      def configure(&blk)
        yield self
      end
    end
    self.mail_sender = "Weirdy <bugs@weirdyapp.com>"
    self.app_name = "My application"
    self.exceptions_per_page = 20
    self.shown_stack = 10
    self.notifier_proc = lambda { |email, wexception| email.deliver }
    self.use_main_app_controller = false
  end
end

ActionController::Base.send(:include, Weirdy::ControllerInstanceMethods)
