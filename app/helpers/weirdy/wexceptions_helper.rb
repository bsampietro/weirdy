module Weirdy
  module WexceptionsHelper
    def state_change_links(wexception)
      close_link = link_to("Close", state_wexception_path(wexception, state: 'closed'), method: :put, remote: true)
      open_link = link_to("Open", state_wexception_path(wexception, state: 'opened'), method: :put, remote: true)
      ignore_link = link_to("Ignore", state_wexception_path(wexception, state: 'ignored'), method: :put, remote: true)
      case wexception.state
        when Weirdy::Wexception::STATE[:closed]
          raw "#{open_link} &nbsp; #{ignore_link}"
        when Weirdy::Wexception::STATE[:opened]
          raw "#{close_link} &nbsp; #{ignore_link}"
        when Weirdy::Wexception::STATE[:ignored]
          raw "#{close_link} &nbsp; #{open_link}"
      end
    end
  end
end
