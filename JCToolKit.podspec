#
# Be sure to run `pod lib lint JCToolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JCToolKit'
  s.version          = '1.0.0'
  s.summary          = 'JCToolKit快速开发框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        JCToolKit快速开发框架是用于快速高效开发的工具库
                       DESC

  s.homepage         = 'https://github.com/SerilesJam/JCToolKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JiaMiao' => 'hxjiamiao@126.com' }
  s.source           = { :git => 'https://github.com/SerilesJam/JCToolKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'JCToolKit/Classes/*'
  s.public_header_files = 'JCToolKit/Classes/JCToolKit.h'

  s.subspec 'JCDefine' do |ss|
    ss.source_files = 'JCToolKit/Classes/JCDefine/*'
    ss.public_header_files = 'JCToolKit/Classes/JCDefine/*.h'
  end

  s.subspec 'JCCore' do |ss|

    ss.source_files = 'JCToolKit/Classes/JCCore/JCToolKit_Core.h'
    ss.public_header_files = 'JCToolKit/Classes/JCCore/JCToolKit_Core.h'

    ss.subspec 'Category' do |sss|
        sss.source_files = 'JCToolKit/Classes/JCCore/Category/*'
        sss.public_header_files = 'JCToolKit/Classes/JCCore/Category/*.h'
    end

    ss.subspec 'ExtendClasses' do |sss|
        sss.source_files = 'JCToolKit/Classes/JCCore/ExtendClasses/*'
        sss.public_header_files = 'JCToolKit/Classes/JCCore/ExtendClasses/*.h'
    end
    ss.dependency 'JCToolKit/JCDefine'
  end

  s.subspec 'JCUI' do |ss|
    ss.source_files = 'JCToolKit/Classes/JCUI/JCToolKit_UI.h'
    ss.public_header_files = 'JCToolKit/Classes/JCUI/JCToolKit_UI.h'

    ss.subspec 'Category' do |sss|
        sss.source_files = 'JCToolKit/Classes/JCUI/Category/*'
        sss.public_header_files = 'JCToolKit/Classes/JCUI/Category/*.h'
    end

    ss.subspec 'ExtendClasses' do |sss|
        sss.source_files = 'JCToolKit/Classes/JCUI/ExtendClasses/*'
        sss.public_header_files = 'JCToolKit/Classes/JCUI/ExtendClasses/*.h'
    end

    ss.dependency 'JCToolKit/JCCore'
  end

  s.frameworks = 'UIKit', 'ImageIO', 'SystemConfiguration', 'Security', 'Accelerate', 'CoreImage'
  s.dependency 'SAMKeychain'

end
