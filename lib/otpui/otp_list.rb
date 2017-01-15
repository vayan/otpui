module Otpui
  class OtpList
    def initialize(builder)
      @otps = Settings.load.secrets
      @model = Gtk::ListStore.new(String, String)

      renderer = Gtk::CellRendererText.new
      column_name = Gtk::TreeViewColumn.new("Issuer", renderer, { text: 0 })
      column_secret = Gtk::TreeViewColumn.new("Secret", renderer, { text: 1 })
      treeview = Gtk::TreeView.new(@model)

      treeview.append_column(column_name)
      treeview.append_column(column_secret)
      treeview.selection.set_mode(:single)
      builder["scrolled_otps_win"].add_with_viewport(treeview)

      treeview.signal_connect("row_activated") do |_treeview, path, _column|
        iter = @model.get_iter(path)
        Clipboard.copy iter[1]
      end
    end

    def list_size
      i = 0
      @model.each { i += 1 }
      i
    end

    def refresh_values
      @model.each do |_model, path, iter|
        secret = @otps.fetch iter[0]
        totp = ROTP::TOTP.new(secret)
        iter[1] = totp.now.to_s
      end
    end

    def refresh_all
      @model.clear
      @otps.each do |issuer, secret|
        iter = @model.append
        totp = ROTP::TOTP.new(secret)
        iter[0] = issuer
        iter[1] = totp.now.to_s
      end
    end

    def run
      GLib::Timeout.add(1000) do
        list_size == @otps.size ?
          refresh_values :
          refresh_all
        true
      end
    end
  end
end
