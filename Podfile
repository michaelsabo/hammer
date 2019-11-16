# frozen_string_literal: true

platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'RxTest', '~> 4.0'
end

def base
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Gifu'
  pod 'String+Extensions', git: 'https://github.com/BergQuester/SwiftString.git', branch: 'master'
  pod 'Regift', git: 'https://gitlab.com/michaelsabo/Regift', branch: 'master'
  #  pod 'Regift', :path => './../Regift'
end

def base_application
  pod 'ChameleonFramework/Swift', git: 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'NVActivityIndicatorView'
  pod 'Font-Awesome-Swift', git: 'https://github.com/Vaberer/Font-Awesome-Swift'
  pod 'Fabric'
  pod 'BonMot'
  pod 'Crashlytics'
  pod 'MMPopupView', git: 'https://github.com/michaelsabo/MMPopupView'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'RxBlocking', '~> 4.0'
end

target 'Hammer' do
  base
  target 'HammerTests' do
    inherit! :search_paths
    testing_pods
  end
  base_application
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    next if target.name.include?('MMPopupView')

    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.1'
    end
  end
end
