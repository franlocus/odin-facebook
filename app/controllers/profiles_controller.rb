class ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile
  end

  def update
    if current_user.profile.update(profile_params)
      redirect_to user_path(current_user), notice: 'Profile updated successfully!'
    else
      flash.now[:notice] = 'Couldnt update, try again!'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:country, :phone, :age, :contact_email, :hobbies, :interests, :description, :photo)
  end
end
