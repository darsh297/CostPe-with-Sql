class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  def index
        if current_user.role_id.in?([2, 3, 4, 5])
          @filtered_users = User.where(company_id: current_user.company_id, isactive: true, role_id: [2, 3, 4, 5,6])
        else
          if current_user.role.role_name == "Root"
            if params[:company_id].present?
              @filtered_users = User.where(company_id: params[:company_id])
            else
              @filtered_users = User.all
            end
          else
            @filtered_users = User.all
          end
        end
      end

      def new
        @user = User.new
      end

      def add_user
      end

      def create
        # binding.pry
        @user = User.new(user_params)
        # binding.pry
        # If the role is 2, set designation_id and department_id to nil
        if @user.role.role_name == "Company Admin"
          @user.designation_id = nil
          @user.department_id = nil
        end

        if @user.save
          flash[:notice] = "#{@user.email} created successfully."

        UserMailer.new_user_email(@user).deliver_now
          redirect_to users_path
        else
          flash[:notice] = "User cannot be created."
          puts @user.errors.full_messages  # Add this line to print validation errors to console
          render :new
        end
      end

      def show
        @user = User.find(params[:id])

      end


      def edit
        @user = User.find(params[:id])
      end
      def update

        # binding.pry

        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to @user, notice: 'User profile was successfully updated.'
        else
          render :edit
        end
      end



def soft_delete
  @user = User.find(params[:id])

  unless @user.role.role_name == "Root"
    @user.soft_delete
    redirect_to users_path, notice: 'User was successfully deleted.'
  else
    redirect_to users_path, alert: 'Cannot delete user with role ID 1.'
  end
end

    end


    private


    def user_params
      if action_name == 'create'
        params.require(:user).permit(:profile_picture, :email, :password, :role_id, :company_id, :department_id, :designation_id)
      elsif action_name == 'update'
       params.require(:user).permit(:avatar, :f_name, :l_name, :accountnumber, :ifsc, :mobileNumber, :joiningDate).permit!
      end
    end
