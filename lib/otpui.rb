require "uri/query_params"
require "glib2"
require "gtk3"
require "rotp"
require "clipboard"
require "zxing"

require "otpui/version"
require "otpui/log"
require "otpui/resources"
require "otpui/settings"
require "otpui/otp_list"

module Otpui
  class Main
    def on_menuitem_about_activate(object)
      @about_window.show
    end

    def on_main_window_destroy(object)
      Gtk.main_quit()
    end

    def on_settings_menu_item_activate(object)
      dialog = SettingsDialog.new
      dialog.show
    end

    def on_menuitem_add_otp_code_activate(object)
      @builder["otp_add_via_code_dialog"].show
    end

    def on_new_otp_button_activate(object)
      @settings.add_secret(
        @builder["new_otp_issuer"].text,
        @builder["new_otp_secret"].text
      )
      @builder["otp_add_via_code_dialog"].hide
    end

    def on_menuitem_add_otp_qrcode_activate(object)
      dialog = Gtk::FileChooserDialog.new(
        title: "Choose a QRCode",
        action: Gtk::FileChooserAction::OPEN,
        parent: @main_window,
        buttons: [
          [Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT],
          [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]
        ]
      )

      if dialog.run == Gtk::ResponseType::ACCEPT
        uri = URI(ZXing.decode(dialog.filename))

        @settings.add_secret(
          uri.query_params["issuer"],
          uri.query_params["secret"]
        )

        dialog.destroy
      elsif
        dialog.destroy
      end
    end

    def connect_signals
      @builder.connect_signals do |handler|
        begin
          method(handler)
        rescue
          Log.debug "#{handler} not yet implemented!"
        end
      end
    end

    def start
      logo = GdkPixbuf::Pixbuf.new(file: Resources.get_icon("logo.png"))
      @settings = Settings.load
      Gtk::Window.set_default_icon(logo)
      @builder = Gtk::Builder.new
      @builder.add_from_file Resources.get_glade("main.glade")
      @about_window = @builder["about_window"]
      @about_window.version = Otpui::VERSION
      @about_window.logo = logo

      @main_window = @builder["main_window"]

      otp_list = OtpList.new(@builder)
      otp_list.run

      connect_signals

      @main_window.show_all

      Gtk.main
    end
  end
end
