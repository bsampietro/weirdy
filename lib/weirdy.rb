require "weirdy/engine"

module Weirdy
  def self.create_exception(exception, data = {})
    Wexception.wcreate(exception, data)
  end
  
  class Config
    class << self
      attr_accessor :daily_mail, :mail_queuer, :mail_sender, :mail_recipients, :app_name
      
      def configure(&blk)
        yield self
      end
    end
    #self.mail_recipients = "noone@nodomain.com" # will send if this field is present
    self.daily_mail = false
    self.mail_queuer = :none
    self.mail_sender = "Weirdy <bugs@weirdyapp.com>"
    self.app_name = "My application"
  end
end
