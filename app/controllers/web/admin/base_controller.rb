module Web
  module Admin
    class BaseController < Web::BaseController
      before_action :require_admin!

      private

      def require_admin!
        return if current_user.admin?

        redirect_to dashboard_path,
                    alert: "You are not authorized to access this page."
      end
    end
  end
end