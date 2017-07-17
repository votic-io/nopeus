module Shoppe
  module Api
    class AttachmentsController < BaseApiController

      	def destroy
	      	@attachment = Shoppe::Attachment.find_by!(token: params[:id])
	      	@attachment.parent.touch

	      	@attachment.destroy
	      	respond_to do |format|
	            format.json { render json: {:data => 'OK'}, :status => 200}
          	end
	    end

    end
  end
end