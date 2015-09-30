class WelcomeController < ApplicationController
	def index
		@hora = Time.now
	end
end
