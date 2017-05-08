#
# Be sure to run `pod lib lint LETimeIntervalPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LETimeIntervalPicker'
  s.version          = '1.1'
  s.summary          = 'A UIDatePicker for time intervals.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ludvigeriksson/LETimeIntervalPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ludvigeriksson' => 'ludvigeriksson@icloud.com' }
  s.source           = { :git => 'https://github.com/ludvigeriksson/LETimeIntervalPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ludvigerikss0n'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LETimeIntervalPicker/Classes/**/*'

  # s.resource_bundles = {
  #   'LETimeIntervalPicker' => ['LETimeIntervalPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
