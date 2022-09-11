Pod::Spec.new do |s|
  s.name         = "SiriusRating"
  s.version      = "1.0.0"
  s.summary      = "A modern utility that reminds your iOS app's users to review the app in a non-invasive way.."
  s.homepage     = "https://github.com/theappcapital/SiriusRating"
  s.license      = "MIT"
  s.author       = "Thomas Neuteboom"
  s.source       = { :git => "https://github.com/theappcapital/SiriusRating.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Sources/*.swift"
  s.swift_version = '5.3'

  s.ios.deployment_target = "14.0"
  s.ios.framework  = 'UIKit'
end
