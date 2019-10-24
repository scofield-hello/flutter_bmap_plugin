#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_bmap_plugin'
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
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.vendored_frameworks =  'Frameworks/BaiduMapAPI_Base.framework','Frameworks/BaiduMapAPI_Cloud.framework','Frameworks/BaiduMapAPI_Map.framework','Frameworks/BaiduMapAPI_Search.framework','Frameworks/BaiduMapAPI_Utils.framework'
  s.vendored_frameworks =  'BaiduMapAPI_Base.framework','BaiduMapAPI_Cloud.framework','BaiduMapAPI_Map.framework','BaiduMapAPI_Search.framework','BaiduMapAPI_Utils.framework'
  s.vendored_libraries = 'Libraries/libssl.a','Libraries/libcrypto.a'
  s.frameworks = 'CoreGraphics','CoreLocation'
  s.resources = 'Resources/mapapi.bundle'
  s.ios.deployment_target = '8.0'
end

