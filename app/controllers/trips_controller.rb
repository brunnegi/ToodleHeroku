class TripsController < ApplicationController
  before_filter :signed_in_user
  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])
    @owner = User.find(@trip.owner)
    @parts = @trip.participants.split(',')
#    @pois = @trip.poi.split(',')
    
    @participates=0
    @parts.each do |part|
      if part == current_user().id
        @participates=1
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, :notice => 'Trip was successfully created.' }
        format.json { render :json => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.json { render :json => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pois/1
  # PUT /pois/1.json
  def vote_poi
    @poi = Poi.find(params[:poi_id])
    @trip = Trip.find(params[:trip_id])
    @newvoters=@poi.voters.clone<<","<<current_user.id.to_s

    respond_to do |format|
      if @poi.update_attribute(:voters,@newvoters)
        format.html { redirect_to @trip, :notice => 'Vote successfully submitted.'}#, id:@trip.id }
        format.json { head :no_content }
      else
        format.html { redirect_to @trip }
#        format.html { render :action => "edit" }
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pois/1
  # PUT /pois/1.json
  def set_definitive_poi
    @poi = Poi.find(params[:poi_id])
    @trip = Trip.find(params[:trip_id])
    @user = current_user
    
    if not (@user.access_token.nil? or @user.access_token_secret.nil?)
		client = TwitterOAuth::Client.new(
			:consumer_key => 'alwFryIK72CGExT3if5tg',
			:consumer_secret => 'hQMyVkl57tSGoGMseYfvHn1brTmrBVykM47QMU1es',
			:token => @user.access_token,
			:secret => @user.access_token_secret
		)

		if client.authorized?
			client.update('Set POI \''<<@poi.name<<'\' for trip \''<<@trip.name<<'\' as definitive') # sends a twitter status update
		end
	end
    
    respond_to do |format|
      if @poi.update_attribute(:definitive,true)
        format.html { redirect_to @trip, :notice => 'POI \''<<@poi.name<<'\' set as definitive'}
        format.json { head :no_content }
      else
        format.html { redirect_to @trip }
#        format.html { render :action => "edit" }
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /pois/1
  # PUT /pois/1.json
  def unset_definitive_poi
    @poi = Poi.find(params[:poi_id])
    @trip = Trip.find(params[:trip_id])

    respond_to do |format|
      if @poi.update_attribute(:definitive,false)
        format.html { redirect_to @trip, :notice => 'POI \''<<@poi.name<<'\' set as not definitive'}
        format.json { head :no_content }
      else
        format.html { redirect_to @trip }
#        format.html { render :action => "edit" }
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /pois/1
  # PUT /pois/1.json
  def add_new_user
    @trip = Trip.find(params[:trip_id])
#    @users=User.paginate(page: 1)#(page: params[:page])
    @users=User.all
    respond_to do |format|
        format.html { render :action => "add_new_user" }
        format.json { render :json => @trip.errors, :status => :unprocessable_entity }
    end
#    render User.all
  end
  
  # PUT /pois/1
  # PUT /pois/1.json
  def add_new_user_do
    @trip = Trip.find(params[:trip_id])
    @user=User.find_by_name(params[:new_user])
    @success=false
    if not @user.nil?
    if @trip.participants_ids_array.include? @user.id
    @newparts=@trip.participants.clone
    else
    @newparts=@trip.participants.clone<<","<<@user.id.to_s
    @success=true
    end
    end

    respond_to do |format|
      if @success
		  if @trip.update_attribute(:participants,@newparts)
			format.html { redirect_to @trip, :notice => 'User successfully added.'}
			format.json { head :no_content }
		  else
			@users=User.all
			flash.now[:alert]= 'User \''<<params[:new_user]<<'\' could not be added.'
			format.html { render action: "add_new_user"}
			format.json { render :json => @poi.errors, :status => :unprocessable_entity }
		  end
      else
        @users=User.all
		flash.now[:alert]= 'User \''<<params[:new_user]<<'\' could not be added.'
        format.html { render action: "add_new_user"}
        format.json { render :json => @poi.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, :notice => 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end
end
