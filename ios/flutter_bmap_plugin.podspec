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
  s.dependency 'BaiduMapKit'
  s.dependency 'BMKLocationKit'
  s.resources = 'Resources/mapapi.bundle','Resources/Icon_end.png','Resources/Icon_road_blue_arrow.png','Resources/Icon_road_green_arrow.png','Resources/Icon_road_red_arrow.png','Resources/Icon_road_yellow_arrow.png','Resources/Icon_start.png','Resources/marker.png','Resources/nav_arrow.png'
  s.ios.deployment_target = '8.0'
end

