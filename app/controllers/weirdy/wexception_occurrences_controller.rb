require_dependency "weirdy/application_controller"

module Weirdy
  class WexceptionOccurrencesController < ApplicationController
  	def index
  		@wexception_occurrences = WexceptionOccurrence.
  			where(wexception_id: params[:wexception_id]).
  			order("happened_at DESC").
  			limit(Weirdy::Config.shown_occurrences)
  	end
  end
end
