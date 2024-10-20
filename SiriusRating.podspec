Pod::Spec.new do |s|
  s.name          = "SiriusRating"
  s.version       = "1.0.8"
  s.summary       = "A modern utility that reminds your iOS app's users to review the app in a non-invasive way.."
  s.homepage      = "https://github.com/theappcapital/SiriusRating"
  s.license       = "MIT"
  s.author        = "Thomas Neuteboom"
  s.source        = { :git => "https://github.com/theappcapital/SiriusRating-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/SiriusRating/**/*.{h,m,swift}"
  s.resources     = ["Sources/SiriusRating/Resources/**/*"]
  s.swift_version = '5.4'
  s.ios.deployment_target = "13.0"
end
