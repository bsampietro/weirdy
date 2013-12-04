require 'test_helper'

module Weirdy
  class WeirdyTest < ActiveSupport::TestCase
    def setup
      
    end
    
    test "should log exceptions with public method" do
      raise RuntimeError, "Some error message" rescue exception = $!
      wexception = Weirdy.log_exception(exception)
      assert_equal "RuntimeError", wexception.kind
      assert_equal "Some error message", wexception.last_message
    end
    
    test "should send an email with public method" do
      Weirdy::Config.mail_recipients = ["doug@mailer.com", "andrew@mailer.com"]
      Weirdy::Config.app_name = "My App"
      wexception = create_wexception(RuntimeError, "Something is wrong")
      Weirdy.notify_exception(wexception)
      mail = ActionMailer::Base.deliveries.last
      assert_equal "#{Weirdy::Config.app_name}: #{wexception.kind} - \"#{wexception.last_message.truncate(Weirdy::Config.exception_message_max_chars)}\"", mail.subject
      assert_equal Weirdy::Config.mail_recipients, mail.to
    end
    
    test "should not raise and exception when logging weirdy error" do
      raise RuntimeError, "Some error message" rescue exception = $!
      assert_nothing_raised do
        Weirdy.send(:log_weirdy_error, exception)
      end
    end
  end
end
