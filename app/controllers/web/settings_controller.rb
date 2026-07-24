class Web::SettingsController < Web::BaseController
  SETTINGS_TABS = %w[
    profile
    ai_review
    notifications
    github
    billing
  ].freeze

  def show
    @settings = Mock::Settings.data

    @active_tab =
      if SETTINGS_TABS.include?(params[:tab])
        params[:tab]
      else
        "profile"
      end
  end
end