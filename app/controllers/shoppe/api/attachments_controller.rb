module Shoppe
  module Api
    class AttachmentsController < BaseApiController

      	def destroy
	      	@attachment = Shoppe::Attachment.find_by!(token: params[:id])
	      	@attachment.parent.touch
	      	
	      	@attachment.destroy
	      	render status: 'complete'
	    end

    end
  end
end