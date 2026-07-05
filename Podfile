# Podfile — CTSachinWrapperiOSNative
# Run `pod install` after placing this file at the project root (same folder as your .xcodeproj)

platform :ios, '13.0'
use_frameworks!

target 'CTSachinWrapperiOSNative' do
  # Leanplum iOS SDK — pull the latest stable release
  pod 'Leanplum-iOS-SDK'
end

# Xcode 14+ requires codesigning to be disabled for bundle targets
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) &&
       target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
