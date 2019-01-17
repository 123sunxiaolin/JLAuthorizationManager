Pod::Spec.new do |s|
    s.name         = 'JLAuthorizationManager'
    s.version      = '1.1.0'
    s.summary      = 'A Project can provide uniform method for system authorization accesses! '
    s.homepage     = 'https://github.com/123sunxiaolin/JLAuthorizationManager'
    s.license      = 'MIT'
    s.authors      = {'Jack_lin' => '401788217@qq.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/123sunxiaolin/JLAuthorizationManager.git', :tag => s.version}
    s.source_files = 'JLAuthorizationManager/*.{h,m}'
    s.requires_arc = true
end