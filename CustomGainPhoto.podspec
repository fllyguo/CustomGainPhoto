Pod::Spec.new do |s|
  s.name         = "CustomGainPhoto"
  s.version      = "1.0.0"
  s.summary      = "自定义获取相册图片"
  s.description  = <<-DESC
                   私有的自定义获取相册图片，方便以后使用
                   DESC

  s.homepage     = "https://gitee.com/flyrees/CustomGainPhoto"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Flyrees" => "flyrees@163.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://gitee.com/flyrees/CustomGainPhoto.git", :tag => s.version }
  s.source_files  = "CustomGainPhoto/**/*.{h,m}"
  s.frameworks = "Foundation"
  s.requires_arc = true

end
