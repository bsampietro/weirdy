require 'test_helper'

module Weirdy
  class WexceptionsControllerTest < ActionController::TestCase
    test "should get exceptions list with correct http basic auth" do
      create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = "admin/123"
      http_basic_auth_login("admin", "123")
      get :index, use_route: :weirdy
      assert_response :success
      assert_select "tr", 3 # headers, exception title, exception details
    end
    
    test "should not get exceptions list with incorrect http basic auth" do
      Weirdy::Config.auth = "admin/123"
      http_basic_auth_login("admin", "1234")
      get :index, use_route: :weirdy
      assert_response 401
    end
    
    test "should get exceptions list when auth proc returns true" do
      create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| true }
      get :index, use_route: :weirdy
      assert_response :success
      assert_select "tr", 3 # headers, exception title, exception details
    end
    
    test "should not get exceptions list when auth proc returns false" do
      create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| false }
      get :index, use_route: :weirdy
      assert_response :success
      assert_select "html", 0 # nothing is rendered
    end
    
    test "should show closed exceptions on correct parameter" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| true }
      
      get :index, {'state' => 'closed'}, use_route: :weirdy
      assert_response :success
      assert_select "tr", 1 # only title
      
      wexception.change_state(:closed)
      
      get :index, {'state' => 'closed'}, use_route: :weirdy
      assert_response :success
      assert_select "tr", 3 # headers, exception title, exception details
    end
    
    test "can order by occurrences" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| true }
      get :index, {'order' => 'occurrences'}, use_route: :weirdy
      assert_response :success
    end
    
    test "should change state" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| true }
      assert wexception.state?(:opened)
      xhr :put, :state, {'id' => wexception.id, 'state' => 'closed'}, use_route: :weirdy
      wexception.reload
      assert_response :success
      assert wexception.state?(:closed)
    end
    
    test "should handle exceptions with null backtrace" do
      create_wexception(RuntimeError, "Something is wrong", nil)
      create_wexception(RuntimeError, "Something is wrong", nil)
      Weirdy::Config.auth = "admin/123"
      http_basic_auth_login("admin", "123")
      get :index, use_route: :weirdy
      assert_response :success
    end
  end
end
