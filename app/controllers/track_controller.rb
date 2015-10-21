class TrackController < ApplicationController

	require 'rest_client'

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json'}


	def index
		@tracks = Track.all
		respond_to do |format|
			format.json {render json: @tracks}
		end
	end

	def create
		@track = Track.new(welcome_params)
		@data = distancia(@track,lastTrack)
		puts @data
		respond_to do |format|
			if @track.save
				format.json {render json: @data, status: :created}
			else
				format.json {render json: @track.errors, status: :unprocessable_entity}
			end
		end
	end

	def test
		myGps = Track.find_by user: 'Edu'
		@liveGps = Track.where(status: 'live')
		
		@arrayDistance = {}

		@liveGps.each do |point|
			jsonDistancia = JSON.parse distancia(point, myGps)
			puts jsonDistancia
			@arrayDistance[point.user] = jsonDistancia["rows"][0]["elements"][0]["distance"]["text"]
		end

		respond_to do |format|
			if @track.save
				format.json {render json: @data, status: :created}
			else
				format.json {render json: @track.errors, status: :unprocessable_entity}
			end
		end
		
	end

	def distancia (destino, origem)
		base_url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
		uri = "#{base_url}#{origem.latitude},#{origem.longitude}&destinations=#{destino.latitude},#{destino.longitude}&mode=bicycling&key=AIzaSyBy7HiPiBN8d8WRmtP3wu2oc0GeO_0wqas"
		rest_resource = RestClient::Resource.new(uri)
		rest_resource.get
	end

	def welcome_params
		params.require(:track).permit(:latitude, :longitude, :heading, :accuracy)
	end

end
