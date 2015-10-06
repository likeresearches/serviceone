class TrackController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json'}


	def index
		@tracks = Track.all
		respond_to do |format|
			format.json {render json: @tracks}
		end
	end

	def create
		@track = Track.new(welcome_params)
		respond_to do |format|
			if @track.save
				format.json {render json: @track, status: :created}
			else
				format.json {render json: @track.errors, status: :unprocessable_entity}
			end
		end
	end

	def welcome_params
		params.require(:track).permit(:latitude, :longitude, :heading, :accuracy)
	end

end
