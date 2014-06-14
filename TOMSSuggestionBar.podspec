Pod::Spec.new do |s|
  s.name             = "TOMSSuggestionBar"
  s.version          = "0.1.0"
  s.summary          = "Smoothly animated suggestions for text inputs with super ease CoreData hook."
  s.homepage         = "https://github.com/TomKnig/TOMSSuggestionBar"
  s.license          = 'MIT'
  s.author           = { "TomKnig" => "hi@tomknig.de" }
  s.source           = { :git => "https://github.com/TomKnig/TOMSSuggestionBar.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TomKnig'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'
end
