#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name = "fzxing"
  s.version = "0.2.0"
  s.summary = "A new flutter plugin project."
  s.description = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage = "http://github.com/trevorwang"
  s.license = {:file => "../LICENSE"}
  s.author = {"Trevor Wang" => "trevor.wang@qq.com"}
  s.source = {:path => "."}
  s.source_files = "Classes/**/*"
  s.resources = "Assets/fzxing.bundle"
  s.public_header_files = "Classes/**/*.h"
  s.dependency "Flutter"
  s.dependency "LBXScan/LBXZXing", "~> 2.3"
  s.dependency "LBXScan/UI", "~> 2.3"

  s.ios.deployment_target = "8.0"
end
