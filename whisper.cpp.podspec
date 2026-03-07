Pod::Spec.new do |s|
  s.name         = "whisper.cpp"
  s.version      = "1.8.1"
  s.summary      = "Port of OpenAI's Whisper model in C/C++"
  s.description  = "High-performance inference of OpenAI's Whisper automatic speech recognition (ASR) model in pure C/C++"
  s.homepage     = "https://github.com/ggml-org/whisper.cpp"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Georgi Gerganov" => "ggerganov@gmail.com" }
  s.source       = { :git => "https://github.com/ggml-org/whisper.cpp.git", :tag => "v#{s.version}" }
  
  # 平台配置
  s.ios.deployment_target       = ENV['ios.deployment_target']
  s.watchos.deployment_target   = ENV['watchos.deployment_target']
  s.tvos.deployment_target      = ENV['tvos.deployment_target']
  s.osx.deployment_target       = ENV['osx.deployment_target']

  # 源文件
  s.source_files = 
    "src/whisper.cpp",
    "src/whisper.h",
    "ggml/src/ggml.c",
    "ggml/src/ggml-alloc.c",
    "ggml/src/ggml-quants.c",
    "ggml/src/ggml-backend-reg.cpp",
    "ggml/src/ggml-backend.cpp",
    "ggml/src/ggml-opt.cpp",
    "ggml/src/ggml-cpu/ggml-cpu.c",
    "ggml/src/ggml-cpu/ggml-cpu.cpp",
    "ggml/src/ggml-cpu/ggml-cpu-impl.h",
    "ggml/src/ggml-common.h"
  
  s.public_header_files = [
    "include/whisper.h",
    "ggml/include/ggml.h",
    "ggml/include/ggml-alloc.h",
    "ggml/include/ggml-backend.h"
  ]
  
  s.header_dir = "whisper"
  
  # 系统框架
  s.frameworks = ['Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore', 'CoreFoundation', 'Accelerate', 'Metal']
  
  # xcconfig 配置
  s.ios.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.whisper.cpp',
    'ENABLE_BITCODE' => 'NO',
    'SWIFT_VERSION' => ENV['SWIFT_VERSION'] || '5.0',
    'EMBEDDED_CONTENT_CONTAINS_SWIFT' => 'NO',
    'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'NO',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'GCC_PREPROCESSOR_DEFINITIONS' => [
      'GGML_USE_K_QUANTS=1',
      'GGML_USE_ACCELERATE=1',
      'GGML_VERSION=\"0.9.4\"',
      'GGML_COMMIT=\"whisper.cpp-pod\"',
      'WHISPER_VERSION=\"1.8.1\"'
    ].join(" "),
    'HEADER_SEARCH_PATHS' => [
      "$(inherited)",
      "${PODS_TARGET_SRCROOT}/include",
      "${PODS_TARGET_SRCROOT}/ggml/include",
      "${PODS_TARGET_SRCROOT}/ggml/src",
      "${PODS_ROOT}/whisper.cpp/ggml/src"
    ].join(" "),
    'OTHER_CFLAGS' => '-O3 -ffast-math',
    'OTHER_CPLUSPLUSFLAGS' => '-O3 -ffast-math -std=c++17'
  }
  
  s.osx.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.whisper.cpp.mac',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'HEADER_SEARCH_PATHS' => [
      "$(inherited)",
      "${PODS_TARGET_SRCROOT}/include",
      "${PODS_TARGET_SRCROOT}/ggml/include",
      "${PODS_TARGET_SRCROOT}/ggml/src"
    ].join(" ")
  }
  
  # 预编译头文件 (PCH)
  pch_content = <<-EOS
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

#import <Availability.h>

// iOS 版本兼容性
#ifndef __IPHONE_12_0
# warning "This project requires iOS SDK 12.0 or later"
#endif

// 调试宏
#ifdef DEBUG
# pragma clang diagnostic ignored "-Wdocumentation"
# pragma clang diagnostic ignored "-Wpch-date-time"
# pragma clang diagnostic ignored "-Wdeprecated-declarations"
#endif

// GGML 配置宏
#ifndef GGML_USE_K_QUANTS
# define GGML_USE_K_QUANTS 1
#endif

#ifndef GGML_USE_ACCELERATE
# define GGML_USE_ACCELERATE 1
#endif

// C/C++ 互操作性
#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif
EOS

  s.prefix_header_contents = pch_content
  
  # 库依赖
  s.libraries = "c++"
end
