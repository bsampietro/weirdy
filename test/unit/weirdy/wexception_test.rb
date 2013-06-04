require 'test_helper'

module Weirdy
  class WexceptionTest < ActiveSupport::TestCase
    test "should create wexception from simple exception with proper attributes" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      assert_equal "RuntimeError", wexception.kind
      assert_equal "Something is wrong", wexception.message
    end
    
    test "should have one occurrence when creating exception" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      assert_equal 1, wexception.occurrences_count
      assert_equal 1, wexception.occurrences.count
    end
    
    test "should group exceptions by type and message" do
      5.times { |i| create_wexception(RuntimeError, "Something is wrong") }
      assert_equal 1, Wexception.count
      wexception = Wexception.first
      assert_equal 5, wexception.occurrences.count
    end
    
    test "different message is treated as a different wexception" do
      5.times { |i| create_wexception(RuntimeError, "Something is wrong #{i}") }
      assert_equal 5, Wexception.count
    end
    
    test "different exception is a different wexception" do
      runtime_error = create_wexception(RuntimeError, "Something is wrong")
      argument_error = create_wexception(ArgumentError, "Something is wrong")
      assert runtime_error != argument_error
      assert_equal 2, Wexception.count
    end
    
    test "state should be opened when creating an exception" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      assert wexception.state?(:opened)
    end
    
    test "should re open exception if closed and reraised" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      wexception.change_state(:closed)
      assert wexception.state?(:closed)
      create_wexception(RuntimeError, "Something is wrong")
      wexception = Wexception.find(wexception.id)
      assert wexception.state?(:opened)
    end
    
    test "should send an email when creating new exceptions" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      mail = ActionMailer::Base.deliveries.last
      assert_equal "#{Weirdy::Config.app_name}: #{wexception.kind} - \"#{wexception.message}\"", mail.subject
      assert_equal Weirdy::Config.mail_recipients, mail.to
      
      wexception = create_wexception(ArgumentError, "Something is wrong")
      mail = ActionMailer::Base.deliveries.last
      assert_equal "#{Weirdy::Config.app_name}: #{wexception.kind} - \"#{wexception.message}\"", mail.subject
      assert_equal Weirdy::Config.mail_recipients, mail.to
    end
    
    test "should not send an email if exception already exists and opened" do
      create_wexception(RuntimeError, "Something is wrong")
      original_mail = ActionMailer::Base.deliveries.last
      assert_not_nil original_mail
      create_wexception(RuntimeError, "Something is wrong")
      new_mail = ActionMailer::Base.deliveries.last
      assert original_mail.object_id == new_mail.object_id
    end
    
    test "should send an email if exception already exists but closed" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      original_mail = ActionMailer::Base.deliveries.last
      assert_not_nil original_mail
      wexception.change_state(:closed)
      create_wexception(RuntimeError, "Something is wrong")
      new_mail = ActionMailer::Base.deliveries.last
      assert original_mail.object_id != new_mail.object_id
    end
  end
end
