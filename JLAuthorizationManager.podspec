#
# Be sure to run `pod lib lint JLAuthorizationManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLAuthorizationManager'
  s.version          = '1.1.0'
  s.summary          = 'A Project can provide uniform method for system authorization accesses.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/123sunxiaolin/JLAuthorizationManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jacklin' => '401788217@qq.com' }
  s.source           = { :git => 'https://github.com/123sunxiaolin/JLAuthorizationManager.git', :tag => s.version.to_s }
  s.social_media_url = 'https://123sunxiaolin.github.io'
  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'JLAuthorizationManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JLAuthorizationManager' => ['JLAuthorizationManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
