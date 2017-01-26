module Weirdy
  module WexceptionsHelper
    def state_change_links(wexception)
      close_link = link_to("Close", state_wexception_path(wexception, state: 'closed'), method: :put, remote: true)
      open_link = link_to("Open", state_wexception_path(wexception, state: 'opened'), method: :put, remote: true)
      ignore_link = link_to("Ignore", state_wexception_path(wexception, state: 'ignored'), method: :put, remote: true)
      delete_link = link_to("Delete", wexception_path(wexception), method: :delete, remote: true, data: { confirm: "Sure?" })
      case wexception.state
        when Weirdy::Wexception::STATE[:closed]
          raw "#{open_link} &nbsp; #{ignore_link} &nbsp; #{delete_link}"
        when Weirdy::Wexception::STATE[:opened]
          raw "#{close_link} &nbsp; #{ignore_link}"
        when Weirdy::Wexception::STATE[:ignored]
          raw "#{close_link} &nbsp; #{open_link} &nbsp; #{delete_link}"
      end
    end

    def backtrace_display(bt)
      return '' if bt.blank?
      raw(bt.map do |line|
        if Wexception.application_line?(line)
          "<em>#{line}</em>"
        else
          line
        end
      end.join("<br>"))
    end

    def empty_message
      state = params[:state].nil? ? 'opened' : params[:state]
      "There are no #{state} exceptions."
    end
  end
end
