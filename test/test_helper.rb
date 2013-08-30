# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  # creates and returns a wexception from an exception
  def create_wexception(exception_type, message, backtrace = 0)
    raise exception_type, message rescue exception = $!
    exception.set_backtrace(backtrace) unless backtrace == 0
    wexception = Weirdy::Wexception.wcreate(exception)
    return Weirdy::Wexception.find(wexception.id)
  end
  
  def http_basic_auth_login(user, password)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end  
end
