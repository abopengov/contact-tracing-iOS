import UIKit

class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        processOnboardingCheck()
    }

    func processOnboardingCheck() {
        let onboardingNavigator = OnboardingNavigator(navigationController: self.navigationController ?? UINavigationController())

        guard !onboardingNavigator.onboardingCompleted else {
            return
        }

        onboardingNavigator.navigate(from: onboardingNavigator.getLastCompletedScreen())
    }
}
