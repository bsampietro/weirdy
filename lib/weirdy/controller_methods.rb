module Weirdy
  module ControllerMethods
    def weirdy_log_exception(exception, data = {})
      wdata = {'URL' => request.url,
               'Params' => params,
               'Session' => weirdy_extract_user_session,
               'Cookies' => weirdy_extract_user_cookies,
               'Method' => request.method,
               'User Agent' => request.env['HTTP_USER_AGENT'],
               'Referer' => request.env['HTTP_REFERER'],
               'IP' => request.remote_ip}
      wdata.merge!(data)
      Weirdy.log_exception(exception, wdata)
    end
    
    private
    
    def weirdy_extract_user_session
      begin
        wsession = Rails::VERSION::MAJOR >= 4 ? 
          session.instance_variable_get(:@delegate).try(:inspect).to_s :
          session.instance_variable_get(:@env).try(:[], 'rack.session').to_s
      rescue Exception
        wsession = nil
      end
      wsession && wsession.length < 800 ? wsession : nil
    end
    
    def weirdy_extract_user_cookies
      wcookies = cookies.instance_variable_get(:@set_cookies).try(:inspect).to_s rescue nil
      wcookies && wcookies.length < 800 ? wcookies : nil
    end
  end
end