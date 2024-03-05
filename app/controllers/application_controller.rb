class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    render "errors/unauthorized", status: :forbidden
  end
end
