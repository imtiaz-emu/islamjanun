class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  layout 'member'
  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @user = User.includes(:questions => [:upvotes, :downvotes], :answers => [:upvotes, :downvotes]).find(@profile.user.id)
  end

  # GET /profiles/1/edit
  def edit
    if @profile != current_user.profile
      redirect_to edit_profile_path(current_user.profile)
    end
  end


  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:full_name, :mobile, :bio, :photo, :birthday, :title, :fb_link)
    end
end
