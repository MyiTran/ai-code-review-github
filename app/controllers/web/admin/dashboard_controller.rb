module Web
  module Admin
    class DashboardController < Web::BaseController
      def index
        @admin = Mock::AdminDashboard.data
      end
    end
  end
end