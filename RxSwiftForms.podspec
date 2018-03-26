Pod::Spec.new do |s|
  s.name             = "RxSwiftForms"
  s.version          = "1.0.0"
  s.summary          = "iOS Form Management, Binding, and Validation using RxSwift."
  s.description      = <<-DESC
iOS Form Management, Binding, and Validation using RxSwift.

```swift
// sample code
```
                        DESC
  s.homepage         = "https://github.com/hmlongco/RxSwiftForms"                      
  s.license          = 'MIT'
  s.author           = { "Michael Long" => "hmlong@gmail.com" }
  s.source           = { :git => "https://github.com/hmlongco/RxSwiftForms", :tag => s.version.to_s }

  s.requires_arc          = true
  
  s.source_files = 'Sources/*.*'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'

  s.ios.deployment_target = '9.0'

end
