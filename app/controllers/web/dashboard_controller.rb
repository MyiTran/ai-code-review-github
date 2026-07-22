class Web::DashboardController < Web::BaseController
  def index
    @dashboard = Mock::Dashboard.call
  end
end