require_dependency "weirdy/application_controller"

module Weirdy
  class WexceptionsController < ApplicationController
    def index
      scope = Wexception.includes(:occurrences)
      scope = params[:state].present? ?
        scope.state(params[:state]) : scope.state(:opened)
      scope = params[:order] == "occurrences" ?
        scope.order('occurrences_count DESC, last_happened_at DESC') : scope.order('last_happened_at DESC')
      @wexceptions = scope.paginate(:per_page => Weirdy::Config.exceptions_per_page, :page => params[:page])
    end
    
    def state
      @wexception = Wexception.find(params[:id])
      @wexception.change_state(params[:state]) if @wexception
    end
    
    def destroy
      @wexception = Wexception.find(params[:id])
      @wexception.destroy if @wexception
    end
  end
end
