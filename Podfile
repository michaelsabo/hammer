use_frameworks!

def testing_pods
  pod 'Quick', '1.0.0'
  pod 'Nimble', '5.1.0'
  pod 'RxTest', '3.0.1'
end

def base
  pod 'Alamofire', '4.2.0'
  pod 'SwiftyJSON', '3.1.3'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', branch: 'master'
  pod 'NVActivityIndicatorView', '3.0.0'
  pod 'Font-Awesome-Swift', '1.5.3'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MMPopupView', :git => 'https://github.com/michaelsabo/MMPopupView'
  pod 'RxSwift',    '3.0.1'
  pod 'RxCocoa',    '3.0.1'
  pod 'RxBlocking', '3.0.1'
  pod 'SwiftString3', '1.0.11'
  pod 'Regift', :git => 'https://github.com/michaelsabo/Regift.git', branch: 'feature/calculate-frame-count'
  pod 'Gifu'
  pod 'BonMot'
end

target 'Hammer' do
  base
end

target 'Ham-it' do
  pod 'Alamofire', '4.2.0'
  pod 'SwiftyJSON', '3.1.3'
  pod 'SwiftString3', '1.0.11'
  pod 'Regift', :git => 'https://github.com/michaelsabo/Regift.git', branch: 'feature/calculate-frame-count'
end

target 'HammerTests' do
  base
  testing_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name.include?("MMPopupView")
      next
    end
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

