Pod::Spec.new do |s|
  s.name             = "LPActionSheetView"
  s.version          = "0.0.3"
  s.summary          = "fully custom action sheet view"
  s.description      = <<-DESC
                       a fully custom action sheet view
                       DESC
  s.homepage         = "https://github.com/litt1e-p/LPActionSheetView"
  s.license          = { :type => 'MIT' }
  s.author           = { "litt1e-p" => "litt1e.p4ul@gmail.com" }
  s.source           = { :git => "https://github.com/litt1e-p/LPActionSheetView.git", :tag => '0.0.3' }
  s.platform = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'LPActionSheetView/*'
  s.frameworks = 'Foundation', 'UIKit'
end
