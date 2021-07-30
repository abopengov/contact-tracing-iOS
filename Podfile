# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'

def common_app_pods
  pod 'IBMMobileFirstPlatformFoundation', '8.0.2020050515'
  pod 'Herald', '2.0.0'
  pod 'GoogleMaps', '5.1.0'
  pod 'Google-Maps-iOS-Utils', '3.8.0'
end

def common_widget_pods
  pod 'IBMMobileFirstPlatformFoundation', '8.0.2020050515'
end

target 'ABTraceTogether' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for tracer
  common_app_pods

  target 'ABTraceTogetherTests' do
      inherit! :search_paths
    end
end

target 'ABTraceTogetherWidgetExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for tracer
  common_widget_pods
end
