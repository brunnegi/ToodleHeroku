class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

  def new
  @user = User.new
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end 
  
  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User destroyed"
  	redirect_to users_url
  end
  
  def show
   @user=User.find(params[:id])
   @owned_trips = @user.owned_trips.paginate(page: params[:page])
   @trips = @user.trips.paginate(page: params[:page])
   @microposts = @user.microposts.paginate(page: params[:page])
#   @trips = Trip.find(:all, :conditions => ["owner == ?", @user.id])
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
    	sign_in @user
    	flash[:success]="Welcome to Toodle!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  	@user=User.find(params[:id])
  end
  
  def setup_twitter
    if not session[:twitter_request_token]
		client = TwitterOAuth::Client.new(
			:consumer_key => 'alwFryIK72CGExT3if5tg',
			:consumer_secret => 'hQMyVkl57tSGoGMseYfvHn1brTmrBVykM47QMU1es'
		)
		request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}#{request.fullpath}")
		#:oauth_callback required for web apps, since oauth gem by default force PIN-based flow
		#( see http://groups.google.com/group/twitter-development-talk/browse_thread/thread/472500cfe9e7cdb9/848f834227d3e64d )
		session[:twitter_request_token] = request_token.token
		session[:twitter_secret_token] = request_token.secret
		
		redirect_to request_token.authorize_url
    else
		@user = User.find(params[:id])
		
		client = TwitterOAuth::Client.new(
			:consumer_key => 'alwFryIK72CGExT3if5tg',
			:consumer_secret => 'hQMyVkl57tSGoGMseYfvHn1brTmrBVykM47QMU1es'
		)

		new_access_token = client.authorize(
		  session[:twitter_request_token],
		  session[:twitter_secret_token],
		  :oauth_verifier => params[:oauth_verifier]
		)
		
#		session.delete(:twitter_request_token)
#		session.delete(:twitter_secret_token)

		if client.authorized?
#			if @user.update_attributes(access_token: new_access_token.token, access_token_secret: new_access_token.secret)
			if @user.update_attribute(:access_token, new_access_token.token) && @user.update_attribute(:access_token_secret, new_access_token.secret)
			redirect_to @user, notice:'Twitter acc successfully added'#<<'access_token:'<<" "<<new_access_token.token<<' secret:'<<new_access_token.secret
			else
			redirect_to @user, alert:'Twitter acc could not be added'#<<'access_token:'<<new_access_token.token<<' secret:'<<new_access_token.secret<<" errors:"<<@user.errors.messages.inspect
			end
		else
			redirect_to @user, alert:'Twitter acc could not be added'
		end
    end
  end
  
  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(params[:user])
  		flash[:success] = "Profile updated"
  		sign_in @user
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end
  
  private
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end
  	
  	def admin_user
  		redirect_to(root_path) unless current_user.admin?
  	end
  
end
