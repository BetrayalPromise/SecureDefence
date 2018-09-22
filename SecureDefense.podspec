#
# Be sure to run `pod lib lint SecureDefense.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SecureDefense'
  s.version          = '0.0.5'
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
  s.source           = { :git => 'https://github.com/BetrayalPromise/SecureDefence.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SecureDefense/SecureDefense.h'

  # s.resource_bundles = {
  #   'SecureDefense' => ['SecureDefense/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'MessageTrash'

  s.subspec 'MessageCenter' do |ss|
      ss.source_files = 'SecureDefense/MessageCenter.{h,m}'
      ss.public_header_files = 'SecureDefense/MessageCenter.h'
  end

  s.subspec 'Container' do |ss|
    ss.source_files = 'SecureDefense/NS{Array,Dictionary,HashTable,MapTable,MutableArray,MutableDictionary,MutableSet,PointerArray,Set}+Safe.{h,m}'
    ss.public_header_files = 'SecureDefense/NS{Array,Dictionary,HashTable,MapTable,MutableArray,MutableDictionary,MutableSet,PointerArray,Set}+Safe.h'
  end

  s.subspec 'Object' do |ss|
    ss.source_files = 'SecureDefense/NSObject+Safe.{h,m}'
    ss.public_header_files = 'SecureDefense/NSObject+Safe.h'
  end


  s.subspec 'UserDefault' do |ss|
      ss.source_files = 'SecureDefense/NSUserDefaults+Safe.{h,m}'
      ss.public_header_files = 'SecureDefense/NSUserDefaults+Safe.h'
  end

  s.subspec 'Notication' do |ss|
      ss.source_files = 'SecureDefense/NSNotificationCenter+Safe.{h,m}'
      ss.public_header_files = 'SecureDefense/NSNotificationCenter+Safe.h'
  end

end
