require 'test_helper'

module Weirdy
  class WexceptionsHelperTest < ActionView::TestCase
    test "backtrace display" do
      bt1 = ["/somewhere/calling/in/the/framework", 
        "#{Rails.root.join('app', 'models', 'file.rb')}:3:in `index'", 
        "#{Rails.root.join('app', 'controllers', 'file.rb')}:3:in `index'"]
      display1 = backtrace_display(bt1)
      bt2 = ["/somewhere/calling/in/the/framework",
        "/someother/place/calling/in/the/framework",
        "/someother/place2/calling/in/the/framework"]
      display2 = backtrace_display(bt2)
      assert display1.scan("<em>").length == 2 && display1.scan("</em>").length == 2
      assert !display2.include?("<em>")
    end
  end
end
