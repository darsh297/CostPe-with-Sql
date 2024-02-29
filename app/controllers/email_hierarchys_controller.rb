class EmailHierarchysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.role_id == 1
    @email_hierarchys = EmailHierarchy.all

    else
      company_users_ids = User.where(company_id: current_user.company_id).pluck(:id)
      @email_hierarchys = EmailHierarchy.where(user_id: company_users_ids)
    end
  end

  def show
    @email_hierarchy = EmailHierarchy.find(params[:id])
  end

def new
  if ["Project Leader", "Project Manager", "Employee"].include?(current_user.role.role_name)
    redirect_to workreports_path, alert: "Access Denied"
    return
  end

  @users_without_email = User.where(company_id: current_user.company_id)
                             .where.not(id: EmailHierarchy.pluck(:user_id))

  @users = User.where(company_id: current_user.company_id)

  @email_hierarchy = EmailHierarchy.new
end


  def edit

  end

  def update
    to_ids = email_hierarchy_params[:to_ids].reject(&:empty?).join(',')
    cc_ids = email_hierarchy_params[:cc_ids].reject(&:empty?).join(',')

    updated_params = email_hierarchy_params.merge(to_ids: to_ids, cc_ids: cc_ids)
    if @email_hierarchy.update(updated_params)
      redirect_to @email_hierarchy, notice: 'Email Hierarchy was successfully updated.'
    else
      render :edit
    end
  end


  def create
    company_users = User.where(company_id: current_user.company_id)

    company_user_ids = company_users.pluck(:id)

    permitted_params = email_hierarchy_params
    permitted_params[:to_ids] = permitted_params[:to_ids].reject(&:empty?).select { |id| company_user_ids.include?(id.to_i) }.join(',')
    permitted_params[:cc_ids] = permitted_params[:cc_ids].reject(&:empty?).select { |id| company_user_ids.include?(id.to_i) }.join(',')

    email_hierarchy = EmailHierarchy.new(permitted_params)

    if email_hierarchy.save
      redirect_to email_hierarchys_path, notice: 'Email Hierarchy was successfully created.'
    else
      @users = User.where(company_id: current_user.company_id)
      render :new
    end
  end


  def destroy
    @email_hierarchy.destroy
    redirect_to projects_path, notice: 'Email Hierarchy was successfully destroyed.'
  end

  private

  def set_project
    @email_hierarchy = EmailHierarchy.find(params[:id])
  end
  def email_hierarchy_params
    params.require(:email_hierarchy).permit(:user_id, :to_ids, :cc_ids).tap do |whitelisted|
      whitelisted[:to_ids] = params[:email_hierarchy][:to_ids] if params[:email_hierarchy][:to_ids].present?
      whitelisted[:cc_ids] = params[:email_hierarchy][:cc_ids] if params[:email_hierarchy][:cc_ids].present?
    end
  end

  end
