module Weirdy
  module ApplicationHelper
    def append_query_params(new_params)
      present_params = params.reject { |key, value| key.in? 'controller', 'action', 'utf8' }
      present_params.merge!(new_params)
      request.path + '?' + present_params.to_query
    end
    
    def weirdy_time_format(time, ago = false)
      time_str = time.strftime('%b %d, %Y - %H:%M:%S')
      time_str += " (#{time_ago_in_words time} ago)" if ago
      time_str
    end
  end
end
