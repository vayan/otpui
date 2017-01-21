# OTPui

[![Gem version](https://img.shields.io/gem/v/otpui.svg?style=flat-square)
](https://rubygems.org/gems/otpui)
[![Gem downloads](https://img.shields.io/gem/dt/otpui.svg?style=flat-square)
](https://rubygems.org/gems/otpui)
[![Build Status](https://img.shields.io/travis/vayan/otpui.svg?style=flat-square)
](https://travis-ci.org/vayan/otpui)
[![Code Climate](https://img.shields.io/codeclimate/github/vayan/otpui.svg?style=flat-square)
](https://codeclimate.com/github/vayan/otpui)


Basic GTK app to display and copy OTP on Linux

- [x] Import QRCodes made for Google Authenticator
- [x] Import secrets directly
- [x] Copy in clipboard on double click
- [ ] Delete a OTP
- [x] Show timer
- [ ] Stop stealing Google Authenticator logo
- [ ] Be pretty

This is not really secure, only use it if you have an encrypted disk or something.

Every issuers and secrets are stored in cleartext in ~/.config/otpui

![Look at this magnificient UI](https://github.com/vayan/otpui/blob/master/screenshot.png)

## Installation

### With rvm

`rvm use 2.4.0@otpui --create`
`gem install otpui`

### For all users

`sudo gem install otpui`

## Requirements
  * `xclip`
