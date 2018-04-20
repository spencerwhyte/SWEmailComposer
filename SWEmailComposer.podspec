#
# Be sure to run `pod lib lint SWEmailComposer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SWEmailComposer'
  s.version          = '0.1.2'
  s.summary          = 'An Apple-like email composer written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SWEmailComposer gives you the ability to present an email composer to the user WITHOUT sending out the final email through the iOS Mail app. Instead the contents of the email is provided to you through the delegate. Written in Swift.
                       DESC

  s.homepage         = 'https://github.com/spencerwhyte/SWEmailComposer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Spencer Whyte' => 'spencerwhyte@gmail.com' }
  s.source           = { :git => 'https://github.com/spencerwhyte/SWEmailComposer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SWEmailComposer/Classes/**/*'
  
  s.resource_bundles = {
     'SWEmailComposer' => ['SWEmailComposer/Assets/*.xcassets']
  }
  
  s.swift_version = '4.1'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
