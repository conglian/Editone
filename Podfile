# Uncomment the next line to define a global platform for your project
# platform :ios, '14..0'

target 'Editone' do
  platform :ios, '15.0'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Editone
  pod 'RxSwift'
  pod 'RxCocoa'
#  pod 'Alamofire'
  pod 'SnapKit', '5.6.0'
  pod 'Kingfisher', '~> 7.0'
  pod 'MJRefresh', '3.7.5'
  pod 'HandyJSON'
  pod 'MBProgressHUD'
  pod 'IQKeyboardManager'
  pod 'SwiftyStoreKit'
  pod 'SDWebImageSVGCoder'
  pod 'AxcAE_TabBar'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
  
end
