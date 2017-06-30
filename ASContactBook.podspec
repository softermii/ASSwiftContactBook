Pod::Spec.new do |s|
  s.name                        = "ASCustomAlertView"
  s.version                     = '1.0'
  s.summary                     = "This is custom alert notification accepts buttons array witn own handlers"
  s.homepage                    = 'http://softermii.com'
  s.social_media_url            = 'http://twitter.com/anton__dev'
  s.documentation_url           = 'http://softermii.com'
  s.author                      = { 'Anton Stremovskiy'   => 'perlik@gmail.com',
                                    'Max Rachytskyy'     => 'maksym.rachytskyy@softermii.com' }
  s.license                     = { :type => "MIT", :file => "LICENSE" }
  s.source                      = { git: "https://github.com/antons81/ASCustomAlertView.git", tag: "v#{s.version}" }
  s.platform                    = :ios, '9.0'
  s.requires_arc                = true
  s.source_files                = 'Pods/*.{swift, xib}', '*.xib'
  s.ios.frameworks              = %w{ UIKit }
  s.ios.deployment_target       = '9.0'
#  s.swift_version 		= '3.0'
end
