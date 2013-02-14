class PatientsController < ApplicationController
	def show
		@patient = Patient.find(params[:id])
	end

	def index
	end

	def new
    	@patient = Patient.new
	end

	def create
    	@patient = Patient.new(params[:patient])
    	if @patient.save
      	# Handle a successful save.
    	else
      	render 'new'
    	end
	end

	def create
    	@patient = Patient.new(params[:patient])
    	if @patient.save
    	  redirect_to root_path
    	else
    	  render 'new'
    	end
  	end

  	def create
	    @patient = Patient.new(params[:patient])
	    if @patient.save
	      flash[:success] = "Got it"
	      redirect_to root_path
	    else
	      render 'new'
	    end
	end

end
