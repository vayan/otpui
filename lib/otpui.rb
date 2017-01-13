require "glib2"
require "gtk3"
require "rotp"
require "clipboard"

require "otpui/version"
require "otpui/log"
require "otpui/resources"
require "otpui/settings"
require "otpui/settings_dialog"

module Otpui
  class Main
    def start
      def on_main_window_destroy(object)
        Gtk.main_quit()
      end

      def on_settings_menu_item_activate(object)
        dialog = SettingsDialog.new
        dialog.show
      end

      otps = Settings.load[:secrets]

      builder = Gtk::Builder.new
      builder.add_from_file Resources.get_glade("main.glade")

      model = Gtk::ListStore.new(String, String)

      renderer = Gtk::CellRendererText.new
      column_name = Gtk::TreeViewColumn.new("Name", renderer, { text: 0 })
      column_secret = Gtk::TreeViewColumn.new("Secret", renderer, { text: 1 })

      treeview = Gtk::TreeView.new(model)
      treeview.append_column(column_name)
      treeview.append_column(column_secret)
      treeview.selection.set_mode(:single)
      builder["scrolled_otps_win"].add_with_viewport(treeview)

      puts otps

      otps.each do |name, secret|
        iter = model.append
        iter[0] = name
        iter[1] = secret
      end

      builder.connect_signals do |handler|
        begin
          method(handler)
        rescue
          Log.debug "#{handler} not yet implemented!"
        end
      end

      builder["main_window"].show_all

      GLib::Timeout.add(1000) do
        otps.each do |name, secret|
          totp = ROTP::TOTP.new("base32secret3232")
          iter = model.append
          iter[0] = name
          iter[1] = totp.now.to_s
        end
        builder["main_window"].show_all
        true
      end

      Gtk.main
    end
  end
end
