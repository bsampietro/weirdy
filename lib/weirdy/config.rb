module Weirdy
  class Config
    class << self
      attr_accessor :mail_recipients, 
                    :auth,
                    :mail_sender,
                    :app_name, 
                    :exceptions_per_page,
                    :shown_stack,
                    :notifier_proc, 
                    :use_main_app_controller,
                    :shown_occurrences
                    
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
    self.shown_occurrences = 15
  end
end