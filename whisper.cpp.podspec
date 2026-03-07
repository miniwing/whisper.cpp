Pod::Spec.new do |spec|
  spec.name         = "whisper.cpp"
  spec.version      = "1.8.1"
  spec.summary      = "Port of OpenAI's Whisper model in C/C++"
  spec.description  = "High-performance inference of OpenAI's Whisper automatic speech recognition (ASR) model in pure C/C++"
  spec.homepage     = "https://github.com/ggml-org/whisper.cpp"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Georgi Gerganov" => "ggerganov@gmail.com" }
  spec.source       = { :git => "https://github.com/ggml-org/whisper.cpp.git", :tag => "v#{spec.version}" }
  spec.source       = { :path => "." }

  # 平台配置 (参考 build-xcframework.sh)
  spec.ios.deployment_target       = ENV['ios.deployment_target']       || '16.4'
  spec.watchos.deployment_target   = ENV['watchos.deployment_target']   || '6.0'
  spec.tvos.deployment_target      = ENV['tvos.deployment_target']      || '16.4'
  spec.osx.deployment_target       = ENV['osx.deployment_target']       || '13.3'
  spec.visionos.deployment_target  = ENV['visionos.deployment_target']  || '1.0'

  # 源文件 (参考 build-xcframework.sh 中的静态库列表)
  spec.source_files         = 'include/**/*.h',
                              'src/**.{h,m,mm,cpp,cxx}',
                              'ggml/**.{h,m,mm,cpp,cxx}'


  # 公共头文件 (参考 setup_framework_structure 函数)
  spec.public_header_files  = "include/*.{h,hpp}",
                              "ggml/*.{h,hpp}"
  
  
  # 资源文件 (Metal shader)
  spec.resource_bundles     = {
                                'whisper' => ['ggml/src/ggml-metal/ggml-metal.metal']
                              }
  
  # 系统框架 (参考 combine_static_libraries 函数)
  spec.frameworks = ['Foundation', 'Accelerate', 'Metal']
  spec.ios.frameworks = ['UIKit', 'CoreGraphics', 'QuartzCore', 'CoreFoundation', 'CoreML']
  spec.osx.frameworks = ['CoreML']
  
  # xcconfig 配置 (参考 COMMON_CMAKE_ARGS)
  spec.ios.pod_target_xcconfig = {
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
      'GGML_USE_METAL=1',
      'GGML_METAL_EMBED_LIBRARY=1',
      'GGML_METAL_USE_BF16=1',
      'GGML_BLAS=1',
      'GGML_CPU_GENERIC=1',
      'GGML_NATIVE=0',
      'GGML_VERSION=\"0.9.4\"',
      'GGML_COMMIT=\"whisper.cpp-pod\"',
      'WHISPER_VERSION=\"1.8.1\"'
    ].join(" "),
    'HEADER_SEARCH_PATHS' => [
      "$(inherited)",
      "${PODS_TARGET_SRCROOT}/",
      "${PODS_TARGET_SRCROOT}/../",
      "${PODS_TARGET_SRCROOT}/include",
      "${PODS_TARGET_SRCROOT}/ggml/include",
      "${PODS_TARGET_SRCROOT}/ggml/src",
      "${PODS_TARGET_SRCROOT}/ggml/src/ggml-metal",
      "${PODS_ROOT}/whisper.cpp/ggml/src"
    ].join(" "),
    # 参考 COMMON_C_FLAGS
    'OTHER_CFLAGS' => '-O3 -Wno-macro-redefined -Wno-shorten-64-to-32 -Wno-unused-command-line-argument -g',
    'OTHER_CPLUSPLUSFLAGS' => '-O3 -std=c++17 -Wno-macro-redefined -Wno-shorten-64-to-32 -Wno-unused-command-line-argument -g'
  }
  
  spec.osx.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.whisper.cpp.mac',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'GCC_PREPROCESSOR_DEFINITIONS' => [
      'GGML_USE_K_QUANTS=1',
      'GGML_USE_ACCELERATE=1',
      'GGML_USE_METAL=1',
      'GGML_METAL_EMBED_LIBRARY=1',
      'GGML_METAL_USE_BF16=1',
      'GGML_BLAS=1',
      'GGML_NATIVE=0',
      'GGML_VERSION=\"0.9.4\"',
      'GGML_COMMIT=\"whisper.cpp-pod\"',
      'WHISPER_VERSION=\"1.8.1\"'
    ].join(" "),
    'HEADER_SEARCH_PATHS' => [
      "$(inherited)",
      "${PODS_TARGET_SRCROOT}/include",
      "${PODS_TARGET_SRCROOT}/ggml/include",
      "${PODS_TARGET_SRCROOT}/ggml/src",
      "${PODS_TARGET_SRCROOT}/ggml/src/ggml-metal"
    ].join(" "),
    'OTHER_CFLAGS' => '-O3 -Wno-macro-redefined -Wno-shorten-64-to-32 -Wno-unused-command-line-argument -g',
    'OTHER_CPLUSPLUSFLAGS' => '-O3 -std=c++17 -Wno-macro-redefined -Wno-shorten-64-to-32 -Wno-unused-command-line-argument -g'
  }
  
  # 预编译头文件 (PCH)
  pch_content = <<-EOS
  
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

#import <Availability.h>

// iOS 版本兼容性 (参考 IOS_MIN_OS_VERSION=16.4)
#ifndef __IPHONE_16_4
# warning "This project requires iOS SDK 16.4 or later"
#endif

// 调试宏 (参考 COMMON_C_FLAGS)
#ifdef DEBUG
# pragma clang diagnostic ignored "-Wdocumentation"
# pragma clang diagnostic ignored "-Wpch-date-time"
# pragma clang diagnostic ignored "-Wdeprecated-declarations"
# pragma clang diagnostic ignored "-Wmacro-redefined"
# pragma clang diagnostic ignored "-Wshorten-64-to-32"
# pragma clang diagnostic ignored "-Wunused-command-line-argument"
#endif

// GGML 配置宏 (参考 COMMON_CMAKE_ARGS)
#ifndef GGML_USE_K_QUANTS
# define GGML_USE_K_QUANTS 1
#endif

#ifndef GGML_USE_ACCELERATE
# define GGML_USE_ACCELERATE 1
#endif

#ifndef GGML_USE_METAL
# define GGML_USE_METAL 1
#endif

#ifndef GGML_METAL_EMBED_LIBRARY
# define GGML_METAL_EMBED_LIBRARY 1
#endif

#ifndef GGML_METAL_USE_BF16
# define GGML_METAL_USE_BF16 1
#endif

#ifndef GGML_BLAS
# define GGML_BLAS 1
#endif

#ifndef GGML_NATIVE
# define GGML_NATIVE 0
#endif

// C/C++ 互操作性
#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif
EOS

  spec.prefix_header_contents = pch_content
  
  # 库依赖
  spec.libraries = "c++"
end
