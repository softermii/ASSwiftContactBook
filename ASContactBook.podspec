Pod::Spec.new do |s|
  s.name                        = "ASContactBook"
  s.version                     = '1.0.0'
  s.summary                     = "Custom Contact Book picker written in Swift 3.0"
  s.homepage                    = 'http://twitter.com/anton__dev'
  s.social_media_url            = 'http://twitter.com/anton__dev'
  s.documentation_url           = 'http://twitter.com/anton__dev'
  s.author                      = { 'Anton Stremovskiy'   => 'perlik@gmail.com' }
  s.license                     = { :type => "MIT", :file => "LICENSE" }
  s.source                      = { git: "https://github.com/antons81/ASSwiftContactBook.git", tag: "v#{s.version}" }
  s.platform                    = :ios, '10.0'
  s.requires_arc                = true
  s.source_files                = 'Pods/*.{swift, xib}', '*.xib'
  s.ios.frameworks              = %w{ UIKit }
  s.ios.deployment_target       = '10.0'
#  s.swift_version 		= '3.0'
end
