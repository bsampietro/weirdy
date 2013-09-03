require 'test_helper'

module Weirdy
  class WexceptionsHelperTest < ActionView::TestCase
    test "backtrace display" do
      Weirdy::Config.app_directories << "mydir"
      bt1 = ["/mydir/app/helpers/something", "/gems/something", "/mydir/app/models/something"]
      display1 = backtrace_display(bt1)
      bt2 = ["/gems/something", "/gems/something2", "/gems/something3"]
      display2 = backtrace_display(bt2)
      assert display1.scan("<em>").length == 2 && display1.scan("</em>").length == 2
      assert !display2.include?("<em>")
    end
  end
end
