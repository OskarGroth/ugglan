Pod::Spec.new do |s|
  s.name = 'Ugglan'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'The next iOS for Hedvig.'
  s.homepage = 'https://github.com/HedvigInsurance/ugglan'
  s.authors = { 'Sam Pettersson' => 'sam@hedvig.com' }
  s.source = { :git => 'https://github.com/HedvigInsurance/ugglan.git' }

  s.ios.deployment_target = '9.0'
  s.source_files = '*.swift'
  s.swift_version = '4.2'
  s.dependency 'Tempura'
  s.dependency 'PinLayout'
  s.dependency 'SwiftLint'
  s.dependency 'DynamicColor', '~> 4.0.2'
  s.dependency 'SwiftFormat/CLI'
  s.dependency 'Apollo'
  s.dependency 'Apollo/WebSocket'
  s.dependency 'Disk', '~> 0.4.0'
  s.dependency 'FlowFramework', '~> 1.3'
  s.dependency 'FormFramework/Presentation', git: 'https://github.com/hedviginsurance/form.git'
  s.dependency 'FormFramework', git: 'https://github.com/hedviginsurance/form.git'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'UICollectionView+AnimatedScroll', git: 'https://github.com/HedvigInsurance/UICollectionView-AnimatedScroll.git'
  s.dependency 'FlowOn', git: 'https://github.com/HedvigInsurance/FlowOn.git'
  s.dependency 'FlowFeedback', git: 'https://github.com/HedvigInsurance/FlowFeedback.git'
end
