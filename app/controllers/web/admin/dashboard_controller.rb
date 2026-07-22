class Web::Admin::DashboardController < Web::BaseController
  def index
    @admin = Mock::AdminDashboard.data
  end
end