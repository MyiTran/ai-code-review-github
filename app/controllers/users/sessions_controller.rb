module Users
  class SessionsController < Devise::SessionsController
    def new
      redirect_to root_path
    end

    def destroy
      sign_out(:user)

      redirect_to root_path,
                  notice: "Signed out successfully."
    end
  end
end