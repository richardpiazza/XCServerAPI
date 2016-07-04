Pod::Spec.new do |s|
  s.name = "XCServerAPI"
  s.version = "1.0.0"
  s.summary = "API and model classes for interacting with an Xcode Server REST API."
  s.description = <<-DESC
  The Xcode Server REST API can be a powerful tool for interacting and managing Xcode bots and integrations.
  This framework models many of the Xcode Server entities and provides a simple interface for retrieving data.
                     DESC
  s.homepage = "https://github.com/richardpiazza/XCServerAPI"
  s.license = 'MIT'
  s.author = { "Richard Piazza" => "github@richardpiazza.com" }
  s.social_media_url = 'https://twitter.com/richardpiazza'

  s.source = { :git => "https://github.com/richardpiazza/XCServerAPI.git", :tag => s.version.to_s }
  s.source_files = 'Sources/*'
  s.resources = 'Resources/*'
  s.platforms = { :ios => '9.1', :tvos => '9.0' }
  s.frameworks = 'Foundation'
  s.requires_arc = true
  s.dependency 'CodeQuickKit', '~> 2.5'

end
