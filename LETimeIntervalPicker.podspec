Pod::Spec.new do |s|
  s.name             = "LETimeIntervalPicker"
  s.version          = "1.0.0"
  s.summary          = "A UIDatePicker for time intervals."
  s.description      = <<-DESC
                       LETimeIntervalPicker lets you pick a time interval with hours, minutes and seconds.
                       DESC
  s.homepage         = "https://github.com/ludvigeriksson/LETimeIntervalPicker"
  s.screenshots      = "http://i.imgur.com/qi9fHVN.png"
  s.license          = 'MIT'
  s.author           = { "Ludvig Eriksson" => "ludvigeriksson@icloud.com" }
  s.source           = { :git => "https://github.com/ludvigeriksson/LETimeIntervalPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ludvigerikss0n'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LETimeIntervalPicker' => ['Pod/Assets/**/*']
  }

  s.frameworks = 'UIKit'
end