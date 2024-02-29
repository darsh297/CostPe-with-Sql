class HolidaysController < ApplicationController
       load_and_authorize_resource

  def index
    if current_user.role.role_name == "Root"
      @holidays = Holiday.all
    else
       @holidays = Holiday.where(company_id: current_user.company_id)
    end
  end


  def show
    @holiday = Holiday.find(params[:id])
  end

  def edit
    if current_user.role.role_name == "Employee"
      redirect_to holidays_path
    else
    end
  end

  def update
  end

  def new
    if current_user.role.role_name == "Employee"

    redirect_to root_path, alert: "Access denied"
    else

    @holiday=Holiday.new
    @holiday.created_by = current_user.id if current_user.role.role_name == "Root"
    end
  end
def create
  if %w(Employee Project\ Manager Project\ Leader).include?(current_user.role.role_name)
    redirect_to root_path, alert: "Access denied"
  else
    @holiday = Holiday.new(holiday_params)
    @holiday.created_by = current_user.id

    if current_user.role.role_name == "Root"
      @holiday.company_id = params[:holiday][:company_id]
    else
      @holiday.company_id = current_user.company_id
    end

    if @holiday.save
      redirect_to holidays_path
    else
      render 'new'
    end
  end
end


  private

  def holiday_params
    params.require(:holiday).permit(:name , :holiday_date , :company_id , :created_by)
  end


end
