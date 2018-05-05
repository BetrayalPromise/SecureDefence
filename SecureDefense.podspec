#
# Be sure to run `pod lib lint SecureDefense.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SecureDefense'
  s.version          = '0.0.2'
  s.summary          = 'SecureDefense.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
deal with unsafe operate
                       DESC

  s.homepage         = 'https://github.com/BetrayalPromise'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BetrayalPromise' => 'BetrayalPromise@gmail.com' }
  s.source           = { :git => 'https://github.com/BetrayalPromise/SecureDefense.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SecureDefense/*'

  # s.resource_bundles = {
  #   'SecureDefense' => ['SecureDefense/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MessageTrash', '~> 0.0.1'
end
