import IBMMobileFirstPlatformFoundation
import UIKit

class LoadingViewController: UIViewController {
    lazy var onboardingNavigator: OnboardingNavigator = {
        OnboardingNavigator(navigationController: self.navigationController ?? UINavigationController())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.refreshView),
            name: Notification.Name(LanguageChangeNotification),
            object: nil
        )

        if BKLocalizationManager.sharedInstance.needToFetchLocalizationStringsFromServer() {
            showSpinner(onView: self.view)
            BKLocalizationManager.sharedInstance.getLocalizationContentFromServer(Locale.current.languageCode ?? "en")
        } else {
            refreshView()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func refreshView() {
        removeSpinner()

        let privacyManager = PrivacyManager()

        if (onboardingNavigator.successCompleted && privacyManager.shouldCheckForUpdate()) {
            privacyManager.checkForNewPrivacyPolicy { [weak self] updateAvailable in
                if updateAvailable {
                    self?.onboardingNavigator.navigateToPrivacyUpdate()
                } else {
                    self?.navigateToNextScreen()
                }
            }
        } else {
            navigateToNextScreen()
        }
    }

    private func navigateToNextScreen() {
        onboardingNavigator.navigate(from: onboardingNavigator.getLastCompletedScreen())
    }
}
