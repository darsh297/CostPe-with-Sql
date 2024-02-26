class WorkreportsController < ApplicationController
  load_and_authorize_resource
 def index
  @workreports = current_user.workreports.order(date: :desc)
  @users = User.all
end


def allworkreports
  if current_user.role.role_name == "Employee"
     redirect_to unauthorized_path, alert: "Access denied"
  elsif current_user.role.role_name == "Root"
    @workreports = Workreport.order(date: :desc).all
  elsif current_user.role.role_name == "Company Admin"
    user_ids_in_same_company = User.where(company_id: current_user.company_id).pluck(:id)
    @workreports = Workreport.where(user_id: user_ids_in_same_company).order(date: :desc)
  else
    current_user_id = current_user.id
    email_hierarchies = EmailHierarchy.where("to_ids LIKE ? OR cc_ids LIKE ?", "%#{current_user_id}%", "%#{current_user_id}%")
    user_workreport_ids = email_hierarchies.pluck(:user_id).uniq
    @workreports = Workreport.where(user_id: user_workreport_ids).order(date: :desc)
  end
end


def show
   @workreports = Workreport.find(params[:id])
end

  def other
     @workreport = Workreport.new
     @users = User.all


  end


  def new
    # binding.pry
    @workreport = Workreport.new
    @users = User.all

 if params[:user_id].present?
   @workreport.user_id = params[:user_id]
   @workreport.date = Date.current
 elsif current_user.role.role_name == "Employee"
          redirect_to unauthorized_path,alert: "You are not authorized person to access this page"
 else
   set_default_date
 end
end

def create
  @workreport = Workreport.new(workreport_params)
  @workreport.created_by = current_user.id

  if @workreport.save
    if @workreport.user_id == current_user.id
      send_workreport_notification(@workreport, "workreports_path")
    else
      send_workreport_notification(@workreport, "allworkreports_path")
    end
  else
    render 'new'
  end
end


  def edit



   if current_user.role.role_name == "Employee"
  if Time.now.hour >= 12 || @workreport.date < Date.today - 1
    redirect_to @workreport, alert: "You cannot edit this work report after 12 PM or after the next day."
  end
end
end


  def update
    if Time.now.hour >= 12 || @workreport.date < Date.today - 1
      redirect_to @workreport, alert: "You cannot edit this work report after 12 PM or after the next day."
    else
      if @workreport.update(workreport_params)
        redirect_to @workreport, notice: 'Work report was successfully updated.'
      else
        render :edit
      end
    end
  end


  private

  def workreport_params
    params.require(:workreport).permit(:user_id, :created_by, :date, :projects_id, :tasks, :hours, :minutes, :status)
  end

  def set_default_date
    @workreport.date = Date.current
  end
  def can_edit_workreport?
    cutoff_time = Time.new(Date.today.year, Date.today.month, Date.today.day + 1, 12, 0, 0, "+00:00") # 12 PM of the next day
    Time.now < cutoff_time && @workreport.date >= Date.today
  end


  def send_workreport_notification(workreport, redirect_path)
  email_hierarchy = EmailHierarchy.where(user_id: workreport.user_id)
  to_ids = email_hierarchy.pluck(:to_ids).map { |ids| ids.split(',') }.flatten
  cc_ids = email_hierarchy.pluck(:cc_ids).map { |ids| ids.split(',') }.flatten

  to_emails = User.where(id: to_ids).pluck(:email)
  cc_emails = User.where(id: cc_ids).pluck(:email)

  WorkreportMailer.with(workreport: workreport, to_emails: to_emails, cc_emails: cc_emails).created.deliver_now

  redirect_to send(redirect_path)
end


end
