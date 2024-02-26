class EmailHierarchysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.role.role_name == "Root"
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
    users_with_hierarchy = EmailHierarchy.pluck(:user_id).uniq
    @users = User.where(company_id: current_user.company_id).where.not(id: users_with_hierarchy)
    @email_hierarchy = EmailHierarchy.new
  end

  def edit

  end

  def update
    to_ids = email_hierarchy_params[:to_ids].reject(&:empty?).join(',')
    cc_ids = email_hierarchy_params[:cc_ids].reject(&:empty?).join(',')

    # Update the params with the comma-separated strings
    updated_params = email_hierarchy_params.merge(to_ids: to_ids, cc_ids: cc_ids)
    if @email_hierarchy.update(updated_params)
      redirect_to @email_hierarchy, notice: 'Email Hierarchy was successfully updated.'
    else
      render :edit
    end
  end


  def create
    # Fetch only users belonging to the same company as the current user
    company_users = User.where(company_id: current_user.company_id)

    # Extract user IDs from the fetched users
    company_user_ids = company_users.pluck(:id)

    # Filter the `to_ids` and `cc_ids` submitted in the form to ensure they belong to the same company
    permitted_params = email_hierarchy_params
    permitted_params[:to_ids] = permitted_params[:to_ids].reject(&:empty?).select { |id| company_user_ids.include?(id.to_i) }.join(',')
    permitted_params[:cc_ids] = permitted_params[:cc_ids].reject(&:empty?).select { |id| company_user_ids.include?(id.to_i) }.join(',')

    # Create the email hierarchy with the filtered parameters
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
