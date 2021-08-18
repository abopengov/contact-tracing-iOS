import UIKit

class OnboardingNavigator {
    enum Destination: CaseIterable {
        case start
        case welcome
        case howItWorks
        case explanation
        case privacy
        case phoneRegistration
        case pushNotificationPermission
        case blueToothMessage
        case locationPermission
        case success
        case legacyOnboardingCompleted
        case privacyUpdate

        var description: String {
            switch  self {
            case .start:
                return "start"

            case .welcome:
                return "welcome"

            case .howItWorks:
                return "howItWorks"

            case .explanation:
                return "explanation"

            case .privacy:
                return "privacy"

            case .phoneRegistration:
                return "phoneRegistration"

            case .pushNotificationPermission:
                return "pushNotificationPermission"

            case .blueToothMessage:
                return "blueToothMessage"

            case .locationPermission:
                return "LocationPermission"

            case .success:
                return "success"

            case .legacyOnboardingCompleted:
                return "completedBluetoothOnboarding"
            case .privacyUpdate:
                return "privacyUpdate"
            }
        }
    }

    private weak var navigationController: UINavigationController?

    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    // MARK: - Navigator
    func navigate(from destination: Destination) {
        guard destination == .success || destination == .privacyUpdate else {
            navigationController?.pushViewController(
                makeViewController(from: destination),
                animated: true
            )
            return
        }

        showHomeScreen()
    }

    func navigateToPrivacyUpdate() {
        navigationController?.pushViewController(
            PrivacyViewController(
                navigator: self,
                identifier: .privacyUpdate
            ),
            animated: true
        )
    }

    func showHomeScreen() {
        HomeScreenEnum.showHomeScreen()
    }

    // MARK: - Private
    private func makeViewController(from destination: Destination) -> UIViewController {
        switch destination {
        case .start:
            return WelcomeViewController(
                navigator: self,
                identifier: .welcome
            )

        case .welcome:
            welcomeCompleted = true
            return HowItWorksViewController(
                navigator: self,
                identifier: .howItWorks
            )

        case .howItWorks:
            howItWorksCompleted = true
            return ExplanationViewController(
                navigator: self,
                identifier: .explanation
            )

        case .explanation:
            explanationCompleted = true
            return PrivacyViewController(
                navigator: self,
                identifier: .privacy
            )

        case .privacy:
            privacyCompleted = true
            return PhoneNumberRegistrationViewController(
                navigator: self,
                identifier: .phoneRegistration
            )

        case .phoneRegistration:
            phoneRegistrationCompleted = true
            return BluetoothViewController(
                navigator: self,
                identifier: .blueToothMessage
            )

        case .blueToothMessage:
            blueToothMessageCompleted = true
            return LocationPermissionViewController(
                navigator: self,
                identifier: .locationPermission
            )

        case .locationPermission:
            locationPermissionCompleted = true
            return PushNotificationPermissionViewController(
                navigator: self,
                identifier: .pushNotificationPermission
            )

        case .pushNotificationPermission:
            pushNotificationPermissionCompleted = true
            return RegistrationSuccessfulViewController(
                navigator: self,
                identifier: .success
            )

        default:
            return WelcomeViewController(
                navigator: self,
                identifier: .welcome
            )
        }
    }
}

extension OnboardingNavigator {
    var onboardingCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "onboardingCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "onboardingCompleted")
        }
    }

    var storedAppVersion: String? {
        get {
            UserDefaults.standard.string(forKey: "storedAppVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "storedAppVersion")
        }
    }

    var welcomeCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.welcome.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.welcome.description)
        }
    }

    var howItWorksCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.howItWorks.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.howItWorks.description)
        }
    }

    var explanationCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.explanation.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.explanation.description)
        }
    }

    var privacyCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.privacy.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.privacy.description)
        }
    }

    var phoneRegistrationCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.phoneRegistration.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.phoneRegistration.description)
        }
    }

    var pushNotificationPermissionCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.pushNotificationPermission.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.pushNotificationPermission.description)
        }
    }

    var blueToothMessageCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.blueToothMessage.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.blueToothMessage.description)
        }
    }

    var locationPermissionCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.locationPermission.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.locationPermission.description)
        }
    }

    var successCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.success.description) || legacyOnboardingCompleted
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Destination.success.description)
        }
    }

    var legacyOnboardingCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: Destination.legacyOnboardingCompleted.description)
        }
    }

    func getLastCompletedScreen() -> Destination {
        if successCompleted {
            return .success
        } else if !welcomeCompleted {
            return .start
        } else if !howItWorksCompleted {
            return .welcome
        } else if !privacyCompleted {
            return .howItWorks
        } else if !phoneRegistrationCompleted {
            return .privacy
        } else if !blueToothMessageCompleted {
            return .phoneRegistration
        } else if !locationPermissionCompleted {
            return .blueToothMessage
        } else if !pushNotificationPermissionCompleted {
            return .locationPermission
        } else if !successCompleted {
            return .pushNotificationPermission
        }

        return .success
    }
}
