Pod::Spec.new do |s|
s.name         = "MLRefreshControl"
s.version      = "0.0.4"
s.summary      = "Pull down to refresh"

s.homepage     = 'https://github.com/molon/MLRefreshControl'
s.license      = { :type => 'MIT'}
s.author       = { "molon" => "dudl@qq.com" }

s.source       = {
:git => "https://github.com/molon/MLRefreshControl.git",
:tag => "#{s.version}"
}

s.platform     = :ios, '7.0'
s.public_header_files = 'Classes/**/*.h'
s.source_files  = 'Classes/**/*.{h,m}'
s.requires_arc  = true

end
