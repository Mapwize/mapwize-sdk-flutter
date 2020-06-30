#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint Mapwize.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mapwize'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MapwizeSDK', '~>3.0'
  s.dependency 'IndoorLocation'
  s.dependency 'MapboxAnnotationExtension', '~> 0.0.1-beta.1'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
