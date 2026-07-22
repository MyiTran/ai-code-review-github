class Web::BaseController < ActionController::Base
  layout "application"

  protect_from_forgery with: :exception

  before_action :set_mock_current_user

  private

  def set_mock_current_user
    @current_mock_user = Mock::CurrentUser.call
  end
end