require "ruby-libappindicator"
require "rotp"
require "clipboard"

require "otpui/version"
require "otpui/log"
require "otpui/resources"
require "otpui/settings"

module Otpui
  class Indicator
    def add_submenu_activate(name:, parent:)
      sub_menu = Gtk::MenuItem.new name
      sub_menu.signal_connect "activate" do
        yield
      end
      parent.append sub_menu
    end

    def start
      otps = Settings.load[:secrets]

      ai = ::AppIndicator::AppIndicator.new "otp-indicator", "logo-indicator", AppIndicator::Category::APPLICATION_STATUS
      ai.set_icon_theme_path "#{Resources.base_dir}/icons"
      ai.set_status(AppIndicator::Status::ACTIVE)

      root_menu = Gtk::Menu.new

      otps.each do |name, secrets|
        totp = ROTP::TOTP.new(secrets)

        item = Gtk::MenuItem.new name.to_s
        item_actions = Gtk::Menu.new
        item.set_submenu item_actions

        add_submenu_activate name: "Copy", parent: item_actions do
          Clipboard.copy totp.now
        end

        root_menu.append(item)
      end

      add_submenu_activate name: "exit", parent: root_menu do
        Gtk.main_quit
      end

      root_menu.show_all

      ai.set_menu(root_menu)

      Gtk.main
    end
  end
end
