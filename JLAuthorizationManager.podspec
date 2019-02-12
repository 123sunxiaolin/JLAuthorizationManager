#
# Be sure to run `pod lib lint JLAuthorizationManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLAuthorizationManager'
  s.version          = '2.0.1'
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
  
  s.default_subspec  = 'All'
  
  s.subspec 'All' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Base/', 'JLAuthorizationManager/Classes/Permissions/'
  end
  
  s.subspec 'Base' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Base/*'
  end
  
  s.subspec 'AuthorizationManager' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/AuthorizationManager/*'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Microphone' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLMicrophonePermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Notification' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLNotificationPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Photos' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLPhotosPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'CellularNetwork' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLCellularNetWorkPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Contact' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLContactPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Calendar' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLCalendarPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Reminder' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLReminderPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Location' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLLocationAlwaysPermission.{h, m}', 'JLAuthorizationManager/Classes/Permissions/JLLocationInUsePermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'AppleMusic' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLAppleMusicPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'SpeechRecognizer' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLSpeechRecognizerPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Siri' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLSiriPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Motion' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLMotionPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Bluetooth' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLBluetoothPermission.{h,m}', 'JLAuthorizationManager/Classes/Permissions/JLBluetoothPeripheralPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end
  
  s.subspec 'Health' do |ss|
      ss.source_files = 'JLAuthorizationManager/Classes/Permissions/JLHealthPermission.{h,m}'
      ss.dependency 'JLAuthorizationManager/Base'
  end

  
end
