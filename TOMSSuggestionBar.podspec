Pod::Spec.new do |s|
  s.name             = "TOMSSuggestionBar"
  s.version          = "0.1.1"
  s.summary          = "A keyboard accessory that presents suggestions. Suggestions are displayed as morphing labels and fetched from a custom database."
  s.homepage         = "https://github.com/TomKnig/TOMSSuggestionBar"
  s.license          = 'MIT'
  s.author           = { "TomKnig" => "hi@tomknig.de" }
  s.source           = { :git => "https://github.com/TomKnig/TOMSSuggestionBar.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TomKnig'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'

  s.dependency 'TOMSCoreDataManager'
  s.dependency 'TOMSMorphingLabel'
end
