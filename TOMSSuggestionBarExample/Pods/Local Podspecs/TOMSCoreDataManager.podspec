Pod::Spec.new do |s|
  s.name             = "TOMSCoreDataManager"
  s.version          = "0.1.1"
  s.summary          = "Comfortable persistency with CoreData integrated views plus support for an optional RESTful backend."
  s.homepage         = "https://github.com/TomKnig/TOMSCoreDataManager"
  s.license          = 'MIT'
  s.author           = { "TomKnig" => "hi@tomknig.de" }
  s.source           = { :git => "https://github.com/TomKnig/TOMSCoreDataManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TomKnig'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'

  s.framework = 'CoreData'

  s.dependency 'AFIncrementalStore'
end
