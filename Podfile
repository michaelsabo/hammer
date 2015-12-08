source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.4'
use_frameworks!

def testing_pods
  pod 'Quick', '~> 0.8.0'
  pod 'Nimble', '3.0.0'
end

target 'Hammer' do
	pod 'Alamofire', '~> 3.1.0'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
	pod 'ChameleonFramework/Swift'
	pod 'NVActivityIndicatorView'
  pod 'Font-Awesome-Swift'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MMPopupView'
end

target 'HammerTests' do
  testing_pods
end
