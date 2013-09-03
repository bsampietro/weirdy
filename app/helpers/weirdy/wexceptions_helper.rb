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
    
    def display_raised_in(raised_in)
      return '-' if raised_in.blank?
      max_length = 60
      half = max_length / 2
      if raised_in.length > max_length
        method = raised_in.split("#")
        length0 = method[0].length
        length1 = method[1].length
        method[0] = method[0][(length0 - half)..length0]
        method[1] = method[1][0..half]
        response = method.join('#')
        response = "..." + response if length0 > half
        response = response + '...' if length1 > half
        response
      else
        raised_in
      end
    end
  end
end
