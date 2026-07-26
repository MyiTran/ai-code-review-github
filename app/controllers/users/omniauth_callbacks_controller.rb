module Users
  class OmniauthCallbacksController <
    Devise::OmniauthCallbacksController

    def github
      user = Github::AuthenticateUser.new(
        auth: request.env.fetch("omniauth.auth")
      ).call

      sign_in(user)

      redirect_to dashboard_path,
                  notice: "Signed in successfully with GitHub."
    rescue ActiveRecord::RecordInvalid => error
      Rails.logger.error(
        "GitHub OAuth validation failed: " \
        "#{error.record.errors.full_messages.join(', ')}"
      )

      redirect_to root_path,
                  alert: "Could not create your account."
    rescue StandardError => error
      Rails.logger.error(
        "GitHub OAuth failed: " \
        "#{error.class} - #{error.message}"
      )

      redirect_to root_path,
                  alert: "Could not sign in with GitHub."
    end

    def failure
      redirect_to root_path,
                  alert: "GitHub authentication was cancelled."
    end
  end
end