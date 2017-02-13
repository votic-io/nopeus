module Shoppe
  module Api
    class CountriesController < BaseApiController

      def index
        @countries = Shoppe::Country.ordered
        render 'index'
      end
    end
  end
end