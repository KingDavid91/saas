class ProfilesController < ApplicationController
    #Prohibits users that do not have accounts to access these pages
    before_action :authenticate_user!
    #Prohibits users from accessing pages that do not belong to them
    before_action :only_current_user
    
    def new
        # Form where a user can fill out their OWN profile
        @user = User.find(params[:user_id])
        @profile = Profile.new
    end
    
    def create
        @user = User.find(params[:user_id])
        #Associates a User with a Profile Object
        @profile = @user.build_profile(profile_params)
        if @profile.save
            flash[:success] = "Profile Updated!"
            redirect_to user_path(params[:user_id])
        else
            render action: :new
        end
    end
    
    def edit
        @user = User.find(params[:user_id])
        #Sets the Profile Variable to the property set with the user
        @profile = @user.profile
    end
    
    
    def update
        @user = User.find(params[:user_id])
        @profile = @user.profile
        if @profile.update_attributes(profile_params)
            flash[:success] = "Profile Updated!"
            redirect_to user_path(params[:user_id])
        else
            render action: :edit
        end
    end
    
    private
        def profile_params
            params.require(:profile).permit(:first_name, :last_name, :job_title, :phone_number, :contact_email, :description)
        end
        
        def only_current_user
            @user = User.find(params[:user_id])
            redirect_to(root_url) unless @user == current_user
        end
end