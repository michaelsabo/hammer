source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def testing_pods
  pod 'Quick', '~> 0.8.0'
  pod 'Nimble'
end

target 'Hammer' do
  pod 'ReactiveCocoa', '4.0.1'
	pod 'Alamofire', '~> 3.1.0'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
	pod 'ChameleonFramework/Swift'
	pod 'NVActivityIndicatorView'
  pod 'Font-Awesome-Swift'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MMPopupView', :git => 'https://github.com/michaelsabo/MMPopupView'
end

target 'HammerTests' do
  testing_pods
end
