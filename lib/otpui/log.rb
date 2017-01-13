require "logger"

module Otpui
  if !defined? Log or Log.nil?
    Log = Logger.new(STDOUT)
  end
end
