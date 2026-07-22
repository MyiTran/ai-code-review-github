class Web::SettingsController < Web::BaseController
  def show
    @settings = Mock::Settings.data
  end
end