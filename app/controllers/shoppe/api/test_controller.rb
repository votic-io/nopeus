module Shoppe
  module Api
    class TestController < BaseApiController

      def index
        render json: {test: 'okiasdasds'}
      end

    end

  end
end