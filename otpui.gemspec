lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "otpui/version"

Gem::Specification.new do |spec|
  spec.name          = "otpui"
  spec.version       = Otpui::VERSION
  spec.authors       = ["Yann Vaillant"]
  spec.email         = ["gems@vaillant.im"]
  spec.summary       = %q{One Time Password Indicator}
  spec.description   = %q{One Time Password Indicator}
  spec.homepage      = "https://github.com/vayan/otpui"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["otpui"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "rotp"
  spec.add_dependency "ruby-libappindicator"
  spec.add_dependency "clipboard"
end
