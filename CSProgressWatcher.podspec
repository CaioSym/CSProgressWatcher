Pod::Spec.new do |s|

  s.name         = "CSProgressWatcher"
  s.version      = "1.0.0"
  s.summary      = "An alternative to KVO for dealing with `Progress` objects in Swift 3"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                      A Swift 3 Wrapper around `Progress` for those who want to avoid KVO. CSProgressWatcher
                      strips the necessety of writing repetivive, stringly typed, KVO code and dagerous observer
                      management. I hope you will find it usefull. Feature requests and bug reports are welcomed!
                   DESC

  s.homepage     = "https://github.com/CaioSym/CSProgressWatcher"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Caio Sym" => "email@address.com" }
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/CaioSym/CSProgressWatcher.git", :tag => "1.0.0" }
  s.public_header_files = "CSProgressWatcher/CSProgressWatcher.h"

  s.source_files  = "CSProgressWatcher/Sources/*.swift"
  
end
