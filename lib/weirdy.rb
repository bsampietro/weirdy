require "will_paginate"

require "weirdy/engine"

module Weirdy
  def self.log_exception(exception, data = {})
    Wexception.wcreate(exception, data)
  end
  
  def self.notify_exception(wexception)
    Notifier.exception(wexception).deliver
  end
  
  class Config
    class << self
      attr_accessor :mail_recipients, 
                    :auth,
                    :mail_sender,
                    :app_name, 
                    :exceptions_per_page,
                    :shown_stack,
                    :mail_sending_proc, 
                    :use_main_app_controller, 
                    :app_directory
                    
      
      def configure(&blk)
        yield self
      end
    end
    self.mail_sender = "Weirdy <bugs@weirdyapp.com>"
    self.app_name = "My application"
    self.exceptions_per_page = 20
    self.shown_stack = 15
    self.mail_sending_proc = lambda { |email, wexception| email.deliver }
    self.use_main_app_controller = false
  end
end
