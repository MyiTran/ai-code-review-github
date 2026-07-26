class Web::BaseController < ActionController::Base
  layout "web"

  helper UsersHelper

  before_action :authenticate_user!
  private

  def require_admin!
    return if current_user.admin?

    redirect_to dashboard_path,
                alert: "You are not authorized to access this page."
  end
end