Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "AirPlay"
  s.summary = "irPlay lets users track iOS AirPlay availability."
  s.requires_arc = true
 
  s.version = "0.1.1"
 
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  s.author = { "Emilio Alberto Ojeda Mendoza" => "emilio.ojeda.mendoza@gmail.com" }
 
  s.homepage = "https://github.com/eMdOS/AirPlay"
  
  s.source = { :git => "https://github.com/eMdOS/AirPlay.git", :tag => "#{s.version}"}
 
  s.framework = "MediaPlayer"

  s.source_files = "Classes/*.{swift}"

end