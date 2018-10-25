
Pod::Spec.new do |s|
  s.name             = '__ProjectName__'
  s.version          = '0.0.1'
  s.summary          = 'A short description of __ProjectName__.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = '__HomePage__'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '__Author__' => '__Email__' }
  s.source           = { :git => '__SSHURL__', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.subspec 'Core' do |ss|
      ss.source_files = "__ProjectName__/Core/*.{h,m}"
  end
  
  s.subspec 'Actions' do |ss|
      ss.source_files = "__ProjectName__/Actions/*.{h,m}"
      ss.dependency "__ProjectName__/Core"
  end
end
