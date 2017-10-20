

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "WQFunctionCommponents"
  s.version      = "0.0.7"
  s.summary      = "UI功能组件"

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

 s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/wang68543/WQFunctionCommponents.git", :tag => "#{s.version}" }
  s.requires_arc = true

 
    s.subspec 'WQAlertUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQAlertUI/*.{h,m}'
    end 
    s.subspec 'WQBannerLoop' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQBannerLoop/*.{h,m}'
    end
    s.subspec 'WQClendarUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQClendarUI/*.{h,m}'
    end
    # s.subspec 'WQExamineUI' do |ss|
    #   # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
    #   ss.source_files = 'WQFunctionCommponents/WQExamineUI/*.{h,m}'
    # end
    s.subspec 'WQFlowTagUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQFlowTagUI/*.{h,m}'
    end 
    s.subspec 'WQPhotoUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQPhotoUI/*.{h,m}'
    end
    s.subspec 'WQPopSelectionsUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.source_files = 'WQFunctionCommponents/WQPopSelectionsUI/*.{h,m}'
    end
    s.subspec 'WQShareUI' do |ss|
      # ss.dependency 'WQFunctionCommponents/UIHelp/Help'
      ss.resources = ["WQFunctionCommponents/WQShareUI/*.xib"] 
      ss.source_files = 'WQFunctionCommponents/WQShareUI/*.{h,m}'
    end
    s.subspec 'WQSlideMenu' do |ss|
      ss.source_files = 'WQFunctionCommponents/WQSlideMenu/*.{h,m}'
    end 
    s.subspec 'WQVerticalLoopText' do |ss|
      ss.source_files = 'WQFunctionCommponents/WQVerticalLoopText/*.{h,m}'
    end
 
  s.dependency 'WQBaseUIComponents'
end
