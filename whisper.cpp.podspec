Pod::Spec.new do |s|
  s.name         = "whisper.cpp"
  s.version      = "1.8.1"
  s.summary      = "Port of OpenAI's Whisper model in C/C++"
  s.homepage     = "https://github.com/ggml-org/whisper.cpp"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Georgi Gerganov" => "ggerganov@gmail.com" }
  s.source       = { :git => "https://github.com/ggml-org/whisper.cpp.git", :tag => "v#{s.version}" }
  
  s.platform     = :ios, "12.0"
  s.osx.deployment_target = "10.15"
  
  s.source_files = 
    "src/whisper.cpp",
    "ggml/src/ggml.c",
    "ggml/src/ggml-alloc.c",
    "ggml/src/ggml-backend-reg.cpp"
  
  s.public_header_files = "include/whisper.h"
  s.header_mappings_dir = "include"
  
  s.xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "GGML_USE_K_QUANTS=1",
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    "CLANG_CXX_LIBRARY" => "libc++"
  }
  
  s.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "GGML_USE_K_QUANTS=1",
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
  }
  
  # ARM NEON optimization for iOS
  s.pod_target_xcconfig['OTHER_CFLAGS'] = '-O3 -ffast-math'
  
  s.libraries = "c++"
end