module Weirdy
  module ApplicationHelper
    def append_query_params(new_params)
      present_params = params.reject { |key, value| key.in? 'controller', 'action', 'utf8' }
      present_params.merge!(new_params)
      request.path + '?' + present_params.to_query
    end
  end
end
