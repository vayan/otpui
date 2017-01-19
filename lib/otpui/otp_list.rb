module Otpui
  class OtpList
    def initialize(builder)
      @otps = Settings.load.secrets
      @model = Gtk::ListStore.new(String, String)
      @progress_bar = builder["totp_timeout_progress_bar"]

      text_renderer = Gtk::CellRendererText.new

      column_name = Gtk::TreeViewColumn.new("Issuer", text_renderer, { text: 0 })
      column_secret = Gtk::TreeViewColumn.new("Secret", text_renderer, { text: 1 })
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

    def get_current_second(totp, otp)
      future_seconds = 0.0
      while totp.verify(otp, Time.now + future_seconds)
        future_seconds += 1
      end
      future_seconds
    end

    def get_fraction_progress(totp, otp)
      get_current_second(totp, otp) / 30
    end

    def update_row(iter, secret = nil, issuer = nil)
      secret = @otps.fetch iter[0] unless secret
      iter[0] = issuer if issuer

      totp = ROTP::TOTP.new(secret)
      iter[1] = totp.now.to_s
    end

    def refresh_values
      @model.each do |_model, path, iter|
        update_row iter
      end
    end

    def refresh_all
      @model.clear
      @otps.each do |issuer, secret|
        iter = @model.append
        update_row iter, secret, issuer
      end
    end

    def refresh_progress_bar
      totp = ROTP::TOTP.new("progress32secret3232")
      @progress_bar.fraction = get_fraction_progress(totp, totp.now.to_s)
    end

    def run
      GLib::Timeout.add(1000) do
        refresh_progress_bar
        list_size == @otps.size ?
          refresh_values :
          refresh_all
        true
      end
    end
  end
end
