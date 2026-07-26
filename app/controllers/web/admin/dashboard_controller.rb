module Web
  module Admin
    class DashboardController < Web::Admin::BaseController
      def index
        @admin = Mock::AdminDashboard.data
      end
    end
  end
end