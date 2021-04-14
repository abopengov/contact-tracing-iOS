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
        onboardingNavigator.navigate(from: onboardingNavigator.getLastCompletedScreen())
    }
}
