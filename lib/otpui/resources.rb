module Otpui
  class Resources
    def self.base_dir
      "#{File.dirname(__FILE__)}/share/"
    end

    def self.get_icon(name)
      File.join base_dir, "icons", name
    end
  end
end
