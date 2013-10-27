require 'test_helper'

module Weirdy
  class WexceptionOccurrencesControllerTest < ActionController::TestCase
    test "should get wexception occurrences for a wexception" do
      wexception = create_wexception(RuntimeError, "Something is wrong")
      Weirdy::Config.auth = lambda { |controller| true }
      xhr :get, :index, {wexception_id: wexception.id}, use_route: :weirdy
      assert_response :success
      assert_not_nil assigns(:wexception_occurrences)
      assert @response.body.include?(wexception.occurrences.first.message)
    end
  end
end
