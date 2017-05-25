

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "WQFunctionCommponents"
  s.version      = "0.0.2"
  s.summary      = "Usual collection"

  s.description  = <<-DESC 
                      平常自己使用一些频率比较高得工具、控件的封装,后期使用的时候也不断维护、更新 
                    DESC

  s.homepage     = "https://github.com/wang68543/WQFunctionCommponents"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.author             = { "王强" => "wang68543@163.com" }
  # Or just: s.author    = "王强"
  # s.authors            = { "王强" => "wang68543@163.com" }
  # s.social_media_url   = "http://twitter.com/王强"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/wang68543/WQFunctionCommponents.git", :tag => "#{s.version}" }
  s.requires_arc = true
  # s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

# "WQFunctionCommponents",  表示源文件的路径，注意这个路径是相对podspec文件而言的。
   #import "WQConstans.h"
#   s.prefix_header_contents =<<-EOS
#                             #import "WQCache.h"
#                             EOS
#   # s.public_header_files = 'WQFunctionCommponents/*.h'

   s.subspec 'AnmationViews' do |ss|
    ss.subspec 'Animation' do |sss|
      sss.source_files = 'WQFunctionCommponents/AnmationViews/Animation/*.{h,m}'
    end 
  end


  s.subspec 'UIHelp' do |ss|
    ss.subspec 'Help' do |sss|
      sss.resources = ['WQFunctionCommponents/UIHelp/Help/*.xib']
      sss.source_files = 'WQFunctionCommponents/UIHelp/Help/*.{h,m}'
      sss.public_header_files='WQFunctionCommponents/UIHelp/Help/*.h'
    end
    ss.subspec 'AlertUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/AlertUI/*.{h,m}'
    end 
    ss.subspec 'BannerLoop' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/BannerLoop/*.{h,m}'
    end
    ss.subspec 'ClendarUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/ClendarUI/*.{h,m}'
    end
    ss.subspec 'ExamineUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/ExamineUI/*.{h,m}'
    end
    ss.subspec 'FlowTagUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/FlowTagUI/*.{h,m}'
    end 
    ss.subspec 'PhotoUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/PhotoUI/*.{h,m}'
    end
    ss.subspec 'PopSelectionsUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.source_files = 'WQFunctionCommponents/UIHelp/PopSelectionsUI/*.{h,m}'
    end
    ss.subspec 'ShareUI' do |sss|
      sss.dependency 'WQFunctionCommponents/UIHelp/Help'
      sss.resources = ["WQFunctionCommponents/UIHelp/ShareUI/*.xib"] 
      sss.source_files = 'WQFunctionCommponents/UIHelp/ShareUI/*.{h,m}'
    end
    ss.subspec 'SlideMenu' do |sss|
      sss.source_files = 'WQFunctionCommponents/UIHelp/SlideMenu/*.{h,m}'
    end 
    ss.subspec 'VerticalLoopText' do |sss|
      sss.source_files = 'WQFunctionCommponents/UIHelp/VerticalLoopText/*.{h,m}'
    end
  end
    s.subspec 'WQCommonTableView' do |ss|
     ss.dependency 'WQFunctionCommponents/UIHelp/Help'
     ss.source_files = 'WQFunctionCommponents/CommonTableView/**/*.{h,m}'
  end
end
