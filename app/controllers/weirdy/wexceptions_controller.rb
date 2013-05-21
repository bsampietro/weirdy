require_dependency "weirdy/application_controller"

module Weirdy
  class WexceptionsController < ApplicationController
    def index
      @wexceptions = Wexception.includes(:occurrences).all
    end
  end
end
