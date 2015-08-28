#
#  Be sure to run `pod spec lint FMDBx.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FMDBx"
  s.version      = "0.7.0"
  s.summary      = "An extension of FMDB to provide ORM and migration functionality for your iOS application."
  s.homepage     = "https://github.com/kohkimakimoto/FMDBx"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Kohki Makimoto' => 'kohki.makimoto@gmail.com' }
  s.source       = { :git => 'https://github.com/kohkimakimoto/FMDBx.git', :tag => s.version.to_s }
  s.source_files = 'FMDBx/Classes/*.{h,m}'
  s.library      = 'sqlite3'
  s.requires_arc = true
  s.platform     = :ios
  s.dependency 'FMDB'

end
