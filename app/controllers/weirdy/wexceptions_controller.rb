require_dependency "weirdy/application_controller"

module Weirdy
  class WexceptionsController < ApplicationController
    def index
      @wexceptions = Wexception.
        includes(:occurrences).
        order('last_happened_at DESC').
        paginate(:per_page => Weirdy::Config.exceptions_per_page, :page => params[:page])
    end
    
    def state
      @wexception = Wexception.find(params[:id])
      @wexception.change_state(params[:state])
    end
  end
end
