require "weirdy/engine"

module Weirdy
  def self.create_exception(exception, data = {})
    Wexception.wcreate(exception, data)
  end
  
  class Config
    class << self
      attr_accessor :mail_sender, 
                    :mail_recipients, 
                    :app_name, 
                    :exceptions_per_page,
                    :shown_stack,
                    :mail_sending_proc, 
                    :auth, 
                    :use_main_app_controller, 
                    :stack_mark
                    
      
      def configure(&blk)
        yield self
      end
    end
    #self.mail_recipients = "noone@nodomain.com" # will send if this field is present
    self.mail_sender = "Weirdy <bugs@weirdyapp.com>"
    self.app_name = "My application"
    self.exceptions_per_page = 10
    self.shown_stack = 15
    self.mail_sending_proc = lambda { |email| email.deliver } # email.delay.deliver in the case of delayed job
    self.auth = "admin/123" # lambda { |controller| controller.session[:user_id].present? }
    self.use_main_app_controller = false
    self.stack_mark = ['app/controllers', 'app/helpers', 'app/mailers', 'app/models', 'app/views'] # line of the stack to be emphasized as it belongs to the app
  end
end
