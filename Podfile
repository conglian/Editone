# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'Editone' do
#  platform :ios, '15.0'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  use_modular_headers!

  # Pods for Editone
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'LYEmptyView'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'Alamofire'
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'MJRefresh', '~> 3.7.9'
  pod 'HandyJSON'
  pod 'MBProgressHUD'
  pod 'IQKeyboardManager'
  pod 'CocoaLumberjack/Swift'
  pod 'AxcAE_TabBar'
  pod 'AudioKit'
#  pod 'SDWebImageSVGCoder'
#  pod 'AxcAE_TabBar'


post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
  
end
