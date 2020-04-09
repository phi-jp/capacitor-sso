
  Pod::Spec.new do |s|
    s.name = 'CapacitorSso'
    s.version = '0.0.1'
    s.summary = 'If you use this plugin, you can be available for realizing SSO (Single Sign On) at Twitter, Facebook and LINE'
    s.license = 'MIT'
    s.homepage = 'https://github.com/phi-jp/capacitor-sso'
    s.author = ''
    s.source = { :git => 'https://github.com/phi-jp/capacitor-sso', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'GoogleSignIn', '~> 5.0.2'
    s.static_framework = true
  end