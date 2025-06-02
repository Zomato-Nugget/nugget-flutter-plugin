#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nugget_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nugget_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Nugget SDK Flutter Plugin'
  s.description      = <<-DESC
Plugin to integrate Nugget SDK in Flutter.
                       DESC
<<<<<<< HEAD
  s.homepage         = 'https://github.com/Zomato-Nugget/nugget-sdk-ios'
=======
  s.homepage         = 'https://github.com/BudhirajaRajesh/NuggetSDK'
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Zomato' => 'rajesh.budhiraja@zomato.com' }
  s.source           = { :path => '.' }
  s.source_files = 'nugget_flutter_plugin/Sources/nugget_flutter_plugin/**/*'
  s.dependency 'Flutter'
<<<<<<< HEAD
  s.dependency 'NuggetSDK'
=======
>>>>>>> 4ade6faafdd328c2b0d4550e89e7971b5f141c7a
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'nugget_flutter_plugin_privacy' => ['nugget_flutter_plugin/Sources/nugget_flutter_plugin/PrivacyInfo.xcprivacy']}
end
