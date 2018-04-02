jazzy \
  --clean \
  --author "Michael Long" \
  --github_url https://github.com/hmlongco/RxSwiftForms \
  --module RxSwiftForms \
  --xcodebuild-arguments -workspace,RxSwiftForms.xcworkspace,-scheme,RxSwiftForms \
  --exclude /*/MetaTextField* \
  --output ./Documentation/API
