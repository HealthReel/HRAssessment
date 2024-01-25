#
# Be sure to run `pod lib lint HRAssessment.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HRAssessment'
  s.version          = '1.0.0'
  s.summary          = 'HealthReel Assessment Pod for InovCares'

  s.homepage         = 'https://github.com/HealthReel/HRAssessment'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HealthReel' => 'developers@healthreel.com' }
  s.source           = { :git => 'https://github.com/HealthReel/HRAssessment.git' }

  s.ios.deployment_target = '15.0'
  s.source_files = 'HRAssessment/Classes/**/*.swift'
  s.swift_version = '5.0'

  s.resources = [     
  'HRAssessment/Assets.xcassets',
  'HRAssessment/Classes/Resources/Fonts/**/*.{ttf}',
  'HRAssessment/Classes/Resources/*.{mp3,mp4,gif,xcstrings}',
  'HRAssessment/Classes/Views/**/*.{storyboard,strings}'
  ]

  s.resource_bundles = {
     'HRAssessment' => [
     'HRAssessment/Assets.xcassets',
     'HRAssessment/Classes/Resources/Fonts/**/*.{ttf}',
     'HRAssessment/Classes/Resources/*.{mp3,mp4,gif,xcstrings}',
     'HRAssessment/Classes/Views/**/*.{storyboard,strings}'
     ]
   }
  
  s.dependency 'DGCharts' ~> 5.0.0

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
