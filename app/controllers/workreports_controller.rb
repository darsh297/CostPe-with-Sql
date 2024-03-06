class WorkreportsController < ApplicationController
  before_action :authenticate_user!
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
      @workreports = Workreport.where(user_id: user_ids_in_same_company, is_active: true).order(date: :desc)
    elsif current_user.role.role_name == "Project Leader"
      current_user_id = current_user.id
      email_hierarchies = EmailHierarchy.where("to_ids LIKE ? OR cc_ids LIKE ?", "%#{current_user_id}%", "%#{current_user_id}%")
      user_workreport_ids = email_hierarchies.pluck(:user_id).uniq
      @workreports = Workreport.where(user_id: user_workreport_ids,is_active: true).order(date: :desc)
    else
      current_user_id = current_user.id
      email_hierarchies = EmailHierarchy.where("to_ids LIKE ? OR cc_ids LIKE ?", "%#{current_user_id}%", "%#{current_user_id}%")
      user_workreport_ids = email_hierarchies.pluck(:user_id).uniq
      @workreports = Workreport.where(user_id: user_workreport_ids,is_active: true).order(date: :desc)
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

  @workreport = Workreport.new
  @users = User.where(isactive: true)
  @projects = if current_user.role.role_name == "Root"
              Project.where(is_active: true)
            else
              Project.joins(:client).where(clients: { company_id: current_user.company_id }).where(is_active: true)
            end



  if params[:user_id].present?
    @workreport.user_id = params[:user_id]
    @workreport.date = Date.current
  else
    set_default_date
  end

  if current_user.role.role_name == "Employee"
    if Workreport.exists?(user_id: current_user.id, date: Date.today)
    redirect_to workreports_path, alert: "Access Denied"
    return
  end
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
    @workreport = Workreport.find(params[:id])
    @projects = Project.all
    if current_user.role.role_name == "Employee"
      if @workreport.date != Date.today
        redirect_to @workreport, alert: "You can only edit today's work report."
        return
      elsif Time.now.hour >= 20
        redirect_to @workreport, alert: "You cannot edit this work report after 8 PM."
        return
      end
    end
  end

def update
  @workreport = Workreport.find(params[:id]) # Fetch the work report to update

  if current_user.role.role_name == "Employee"
    if @workreport.date != Date.today
      redirect_to @workreport, alert: "You can only update today's work report."
      return
    elsif Time.now.hour >= 20
      redirect_to @workreport, alert: "You cannot update this work report after 8 PM."
      return
    elsif params[:workreport][:date] && Date.parse(params[:workreport][:date]) < Date.yesterday
      redirect_to @workreport, alert: "You cannot edit a work report for a date older than yesterday."
      return
    end
  end

  if @workreport.update(workreport_params)
    redirect_to @workreport, notice: 'Work report was successfully updated.'
  else
    render :edit
  end
end


  def self.users_with_pending_reports
  def new
    @workreport = Workreport.new
    @users = User.all

    if params[:user_id].present?
      @workreport.user_id = params[:user_id]
      @workreport.date = Date.current
    elsif current_user.role.role_name == "Employee"
      redirect_to workreports_path, alert: "Access Denied"
    else
      set_default_date
    end
  end

    yesterday = Date.yesterday
    users_with_reports = Workreport.where(date: yesterday.beginning_of_day..yesterday.end_of_day).pluck(:user_id)

    users_without_reports = User.left_outer_joins(:workreports)
                                 .where.not(id: users_with_reports)
                                 .distinct
                                 .pluck(:email)

    users_without_reports
  end

  def soft_delete
  @workreport = Workreport.find(params[:id])
  @workreport.soft_delete
    redirect_to allworkreports_path, notice: 'Workreport was successfully deleted.'
  end

  private

  def workreport_params
    params.require(:workreport).permit(:user_id, :created_by, :date, :projects_id, :tasks, :hours, :minutes, :status)
  end

  def set_default_date
    @workreport.date = Date.current
  end

  def can_edit_workreport?
    cutoff_time = Time.new(Date.today.year, Date.today.month, Date.today.day + 1, 12, 0, 0, "+00:00")
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
