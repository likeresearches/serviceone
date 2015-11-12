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
		if Track.find_by(user: params[:user]).blank?
			@track = Track.new(welcome_params)
			@track.save
		else
			@track = Track.find_by(user: params[:user])
			@track.update_attributes(welcome_params)
		end

		

		respond_to do |format|
			if @track.save
				format.json {render json: @track, status: :created}
			else
				format.json {render json: @track.errors, status: :unprocessable_entity}
			end
		end
	end

	def return
		track = Track.find_by(user: params[:user])
		
		@data = checkAround(track)
		
		respond_to do |format|
			if track.save
				format.json {render json: @data, status: :created}
			else
				format.json {render json: @track.errors, status: :unprocessable_entity}
			end
		end
	end

	def checkAround(track)
		myGps = Track.find_by(user: track.user)
		#liveGps = Track.where('updated_at >= :one_seconds_ago', :one_seconds_ago => Time.now - 1.seconds)
		liveGps = Track.all

		@arrayDistance = []
		@stringDestination = ""
		
		liveGps.each do |point|
			p = Distance.new
			p.user = point.user
			p.latitude = point.latitude
			p.longitude = point.longitude
			p.heading = point.heading
			p.speed = point.speed
			@stringDestination = @stringDestination + "#{point.latitude},#{point.longitude}|"
			@arrayDistance << p
		end

		jsonDistancia = JSON.parse distancia(@stringDestination, myGps)
		

		@arrayDistance.each_with_index do|item,index|
			item.distancia = jsonDistancia["rows"][0]["elements"][index]["distance"]["text"]
			item.value = jsonDistancia["rows"][0]["elements"][index]["distance"]["value"]
		end


		@arrayDistance.sort_by! &:value
	end

	def distancia (destino, origem)
		base_url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
		uri = "#{base_url}#{origem.latitude},#{origem.longitude}&destinations=#{destino}&mode=bicycling&key=AIzaSyCb4EAvkwEc9b_iLc1lYFgnh1Sf0XyLhfA"
		rest_resource = RestClient::Resource.new(uri)
		rest_resource.get
	end

	def welcome_params
		params.require(:track).permit(:user, :status, :latitude, :longitude, :speed, :heading)
	end

end
