class ClientsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if current_user.role.role_name == "Company Admin"
      @clients = Client.where(company_id: current_user.company_id)
    else
      @clients = Client.all
    end
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.user_id = current_user.id

    if current_user.role.role_name == "Company Admin"
      @client.company_id = current_user.company_id
    end

    if @client.save
      redirect_to clients_path, notice: 'Client Added.'
    else
      render 'new'
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to clients_path, notice: 'Client Updated.'
    else
      render :edit
    end
  end

  def soft_delete
    @client = Client.find(params[:id])
    @client.soft_delete

    redirect_to clients_path, notice: 'Client deactivated.'
  end

  private

  def client_params
    params.require(:client).permit(:user_id, :client_name , :is_active , :company_id )
  end
end
