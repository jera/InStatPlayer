#
# Be sure to run `pod lib lint InStatPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InStatPlayer'
  s.version          = '0.1.2'
  s.summary          = 'InStatPlayer - media player'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  InStatPlayer - customizable media player
  DESC

  s.homepage         = 'https://github.com/tularovbeslan/InStatPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tularovbeslan@gmail.com' => 'tularovbeslan@gmail.com' }
  s.source           = { :git => 'https://github.com/tularovbeslan/InStatPlayer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JiromTomson'
  s.swift_version = '4.2'
  s.ios.deployment_target = '10.0'

  s.source_files = 'InStatPlayer/Classes/**/*'

  s.resource_bundles = {
	  'InStatPlayer' => ['InStatPlayer/Assets/*.xcassets']
  }
  s.frameworks = 'UIKit', 'MediaPlayer', 'AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
