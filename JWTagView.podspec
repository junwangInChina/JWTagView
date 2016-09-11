
Pod::Spec.new do |s|

  s.name         = "JWTagView"
  s.version      = "0.0.1"
  s.summary      = "JWTagView，一款简单易用的标签控件"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWTagView"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.1"
  #版本地址
  s.source       = { :git => "https://github.com/junwangInChina/JWTagView.git", :tag => "0.0.1" }
 
  #库文件路径（相对于.podspec文件的路径）
  s.source_files  = "JWTagView/JWTagView/JWTagView/**/*.{h,m}"
  #是否支持arc
  s.requires_arc = true

end
