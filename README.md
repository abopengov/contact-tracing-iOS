# ABTraceTogether iOS App

ABTraceTogether is the Government of Alberta's implementation of BlueTrace.

BlueTrace is a privacy-preserving protocol for community-driven contact tracing across borders. It allows participating devices to log Bluetooth encounters with each other, in order to facilitate epidemiological contact tracing while protecting users’ personal data and privacy. Visit <https://bluetrace.io> to learn more.

The OpenTrace reference implementation comprises:

- iOS app: [opentrace-community/opentrace-ios](https://github.com/opentrace-community/opentrace-ios)
- Android app: [opentrace-community/opentrace-android](https://github.com/opentrace-community/opentrace-android)
- Cloud functions: [opentrace-community/opentrace-cloud-functions](https://github.com/opentrace-community/opentrace-cloud-functions)
- Calibration: [opentrace-community/opentrace-calibration](https://github.com/opentrace-community/opentrace-calibration)

Setup of the app

## Building the code

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple
2. Install [CocoaPods](https://github.com/CocoaPods/CocoaPods)
3. Clone the repository
4. Run `pod install` at root of project

## Configuration

### Configuring BlueTrace

You can find BlueTrace config variables at `BluetraceConfig.swift`.

### Setting build variables

To configure PROD variables, define them in `Targets > ABTraceTogether > Build Settings > User-Defined` and declare them in `Info.plist`.

## Debug Screen

There is a debug screen accessible within the staging version of the app. This allows you to view the app's Bluetooth communication log. To access it, you first have to set up the app. Then, tap on the home screen image.

## Security Enhancements

SSL pinning is not included as part of the repo

## Statement from Apple

The following is a statement from Apple: "To ensure the credibility of health and safety information, Apple is only accepting COVID-19 related apps from recognised entities such as government organisations, health-focused NGOs, companies deeply credentialed in health issues, and medical or educational institutions. Only developers from one of these recognized entities should submit an app related to COVID-19 to the App Store.

For more information visit <https://developer.apple.com/news/?id=03142020a">

## Known issues

iOS has limitations on background Bluetooth activity. Details are documented in the white paper at [https://bluetrace.io](https://bluetrace.io).
