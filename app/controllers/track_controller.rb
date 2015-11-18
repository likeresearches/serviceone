class TrackController < ApplicationController

	require 'rest_client'

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json'}


	def index
		@tracks = Track.all
		
		if (@tracks[0] != nil)
			@distan = checkAround(@tracks[0])
		else
			@distan = []
		end

		respond_to do |format|
			format.json {render json: @distan}
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

		if (myGps != nil)
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

			@arrayDistance = tempo(@arrayDistance)
		end

		@arrayDistance.sort_by! &:value
	end

	def distancia (destino, origem)
		base_url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
		uri = "#{base_url}#{origem.latitude},#{origem.longitude}&destinations=#{destino}&mode=bicycling&key=AIzaSyD8gA4tBBbbA8SIfQ7YBAwxMvY5wgk3Otg"
		rest_resource = RestClient::Resource.new(uri)
		rest_resource.get
	end

	def tempo(arrayDistance)
		headingInterval = (arrayDistance[0].heading.to_f-5 .. arrayDistance[0].heading.to_f+5)
		arrayDistance.each_with_index do |point, index|
			velRelativa =  arrayDistance[index].speed.to_f - arrayDistance[0].speed.to_f
			puts velRelativa
			if (velRelativa != 0)
				time = ((arrayDistance[index].value.to_f/1000)/velRelativa)*60
				point.tempo = time.round
			else
				point.tempo = 0
			end
		end
		arrayDistance
	end

	def welcome_params
		params.require(:track).permit(:user, :status, :latitude, :longitude, :speed, :heading)
	end

end
