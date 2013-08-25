require "weirdy/engine"

module Weirdy
  def self.create_exception(exception, data = {})
    Wexception.wcreate(exception, data)
  end
  
  class Config
    class << self
      attr_accessor :daily_mail, :mail_queuer, :mail_sender, :mail_recipients, :app_name, :exceptions_per_page,
        :mail_sending_proc
      
      def configure(&blk)
        yield self
      end
    end
    #self.mail_recipients = "noone@nodomain.com" # will send if this field is present
    self.daily_mail = false
    self.mail_sender = "Weirdy <bugs@weirdyapp.com>"
    self.app_name = "My application"
    self.exceptions_per_page = 10
    self.mail_sending_proc = lambda { |email| email.deliver } # email.delay.deliver in the case of delayed job
  end
end
