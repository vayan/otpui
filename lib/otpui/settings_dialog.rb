module Otpui
  class SettingsDialog
    def initialize
      @builder = Gtk::Builder.new
      @builder.add_from_file Otpui::Resources.get_glade("settings.glade")

      @settings = Settings.load

      @builder["cancel_button"].signal_connect "clicked" do
        close_callback
      end

      @builder["close_btn"].signal_connect "clicked" do
        close_callback
      end
    end

    def show
      @builder["preferences_dialog"].show
    end

  private
    def close_callback
      @settings.save
      @builder["preferences_dialog"].destroy
    end
  end
end
