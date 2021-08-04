Pod::Spec.new do |s|
  	s.name             = "UUSwiftUX"
  	s.version          = "1.0.0"

  	s.description      = <<-DESC
                       UUSwiftUX is a framework to extend the base Foundation and UIKit classes. UUSwiftUX eliminates many of the tedious tasks associated with Swift development such as date formating and string manipulation.
                       DESC
  	s.summary          = "UUSwiftUX extends Foundation and UIKit to add additional functionality to make development more efficient."

  	s.homepage         = "https://github.com/SilverPineSoftware/UUSwiftUX"
  	s.author           = "Silverpine Software"
  	s.license          = { :type => 'MIT' }
  	s.source           = { :git => "https://github.com/SilverPineSoftware/UUSwiftUX.git", :tag => s.version.to_s }

	s.ios.deployment_target = "10.0"
	s.osx.deployment_target = "10.10"
	s.swift_version = "5.0"

	s.subspec 'Core' do |ss|
    	ss.source_files = 'UUSwift/*.{swift}'
    	ss.ios.frameworks = 'UIKit', 'Foundation'
		ss.osx.frameworks = 'CoreFoundation'
		ss.tvos.frameworks = 'UIKit', 'Foundation'
  	end

end

