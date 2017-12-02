
Pod::Spec.new do |s|
    s.name         = "Runtime"
    s.version      = "0.1.0"
    s.summary      = "Runtime"
    s.description  = <<-DESC
    Runtime abilities for native swift objects.
    DESC
    s.homepage     = "https://github.com/wickwirew/Runtime"
    s.license      = "MIT"
    s.author       = { "Wesley Wickwire" => "wickwirew@gmail.com" }
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/wickwirew/Runtime.git" }
    s.source_files  = 'Runtime/**/*.swift'
end
