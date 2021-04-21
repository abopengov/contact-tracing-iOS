# ABTraceTogether iOS App

ABTraceTogether is the Government of Alberta's Contact Tracing application that uses Herald.

Herald provides reliable Bluetooth communication and range finding across a wide range of mobile devices, allowing Contact Tracing and other applications to have regular and accurate information to make them highly effective. More information is available [here](./herald/Herald.md).

## Building the code

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple
2. Install [CocoaPods](https://github.com/CocoaPods/CocoaPods)
3. Clone the repository
4. Run `pod install` at root of project

## Configuration

### Setting build variables

To configure PROD variables, define them in `Targets > ABTraceTogether > Build Settings > User-Defined` and declare them in `Info.plist`.

## Debug Screen

There is a debug screen accessible within the staging version of the app. This allows you to view the app's Bluetooth communication log. To access it, you first have to set up the app. Then, tap on the home screen image.

## Linting

There's a build script in `Targets > ABTraceTogether > Build Phases > Swiftlint` which runs [SwiftLint](https://github.com/realm/SwiftLint) on Build.
Run `{PODS_ROOT}/SwiftLint/swiftlint autocorrect` to auto-fix some linting errors.

## Security Enhancements

SSL pinning is not included as part of the repo

## Statement from Apple

The following is a statement from Apple: "To ensure the credibility of health and safety information, Apple is only accepting COVID-19 related apps from recognised entities such as government organisations, health-focused NGOs, companies deeply credentialed in health issues, and medical or educational institutions. Only developers from one of these recognized entities should submit an app related to COVID-19 to the App Store.

For more information visit <https://developer.apple.com/news/?id=03142020a">
