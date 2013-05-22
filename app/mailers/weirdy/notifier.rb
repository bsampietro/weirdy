module Weirdy
  class Notifier < ActionMailer::Base
    default from: Weirdy::Config.mail_sender
    
    def exception(wexception)
      @wexception = wexception
      mail :to => Weirdy::Config.mail_recipients, 
           :subject => "#{Weirdy::Config.app_name}: #{wexception.kind} - \"#{wexception.message}\""
    end
  end
end
