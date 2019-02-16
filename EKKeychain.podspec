#
#  Be sure to run `pod spec lint EKKeychain.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "EKKeychain"
  s.version      = "0.0.1"
  s.summary      = "easy to use keychain"
  s.description  = 'easy to use keychain'
  s.homepage     = "https://github.com/ConfuseedSui/EKKeychain"
  s.license      = 'MIT'
  s.author       = { "lx" => "suilx94@163.com" }
  s.platform     = :ios, "8.0" 
  s.source       = { :git => 'https://github.com/ConfusedSui/EKKeychain.git', :tag => s.version }
  s.source_files  = "EKKeychain/**/*"
  s.public_header_files = 'EKKeychain/EKKeychain.h'
  s.requires_arc = true 
  s.frameworks   = "Security"
end
