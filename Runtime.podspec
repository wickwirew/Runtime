
Pod::Spec.new do |s|
    s.name         = "Runtime"
    s.version      = "2.2.5"
    s.summary      = "Runtime"
    s.description  = <<-DESC
    Runtime abilities for native swift objects.
    DESC
    s.homepage     = "https://github.com/wickwirew/Runtime"
    s.license      = "MIT"
    s.author       = { "Wesley Wickwire" => "wickwirew@gmail.com" }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.10'
    s.source       = { :git => "https://github.com/wickwirew/Runtime.git", :tag => s.version }
    s.source_files = 'Sources/**/*.{swift,h}'
end
