class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.isactive?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      sign_out(resource_name)
      flash[:alert] = "Your account is not active. Please contact the administrator."
      redirect_to new_user_session_path
    end
  end
end
