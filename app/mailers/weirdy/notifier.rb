module Weirdy
  class Notifier < ActionMailer::Base
    helper Weirdy::ApplicationHelper
    default from: Weirdy::Config.mail_sender
    
    def exception(wexception)
      @wexception = wexception
      mail :to => Weirdy::Config.mail_recipients, 
           :subject => "#{Weirdy::Config.app_name}: #{wexception.kind} - \"#{wexception.last_message.truncate(Weirdy::Config.exception_message_max_chars)}\""
    end
  end
end
