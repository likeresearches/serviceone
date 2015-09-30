class WelcomeController < ApplicationController
	def index
		@track = Welcome.all
		respond_to do |format|
			format.json {render json: @track}
		end
	end
end
