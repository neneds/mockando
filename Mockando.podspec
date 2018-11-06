#
# Be sure to run `pod lib lint Mockando.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mockando'
  s.version          = '0.1.0'
  s.summary          = 'Mockando helps developers to test apps by recording and playing json mock files'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Mockando helps developers to test apps by recording and playing json mock files
    
    Inside Mockando we have 2 important features:
      - Recorder: Record Models that conforms with Codable protocol and save them in a .json file.
      - Player: Load a json file and use them to mock your app behavior or test specific conditions.
  DESC

  s.homepage         = 'https://github.com/neneds/Mockando'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'neneds' => 'dennis.merli1@gmail.com' }
  s.source           = { :git => 'https://github.com/neneds/Mockando.git', :tag => s.version.to_s }


  s.ios.deployment_target = '11.3'
  s.swift_version = '4.2'

  s.source_files = 'Mockando/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Mockando' => ['Mockando/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
