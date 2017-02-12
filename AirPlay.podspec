
Pod::Spec.new do |s|

  s.name             = "AirPlay"
  s.version          = "3.0.0"
  s.summary          = "AirPlay lets users track iOS AirPlay availability and provides extra information about AirPlay connection status."


  s.homepage         = "https://github.com/eMdOS/AirPlay"
  s.license          = 'MIT'
  s.author           = { "eMdOS" => "emilio.ojeda.mendoza@gmail.com" }
  s.source           = { :git => "https://github.com/eMdOS/AirPlay.git", :tag => 'v'+s.version.to_s }
  s.social_media_url = 'https://twitter.com/_eMdOS_'
  
  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = 'Sources/'

  s.frameworks       = 'MediaPlayer', 'AVFoundation'

end
