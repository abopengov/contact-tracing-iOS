import CoreData
import IBMMobileFirstPlatformFoundation
import Lottie
import UIKit
import WebKit

// swiftlint:disable:next type_body_length
class HomeViewController: UIViewController {
    var allPermissionOn = true
    var bleAuthorized = true
    var blePoweredOn = true
    var pushNotificationGranted = true
    var locationAuthorized = true
    var localPreferredScreenEdgesDeferringSystemGestures: UIRectEdge = []
    var fetchedResultsController: NSFetchedResultsController<Encounter>?
    var blurredStatusBar: UIVisualEffectView?
    weak var appPermissionDelegate: AppPermissionDelegate?
    weak var appNotWorkingDelegate: AppNotWorkingDelegate?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.clipsToBounds = false
        scrollView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height * -1 - 6, left: 0, bottom: 0, right: 0)
        scrollView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = homeScreenBackgroundColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = homeScreenBackgroundColor
        return view
    }()

    lazy var appWorkingView: UIView? = {
        guard let appWorkingNibView = getView("AppWorkingView") as? AppWorkingView else {
            return nil
        }
        appWorkingNibView.homeViewControllerDelegate = self
        appWorkingNibView.translatesAutoresizingMaskIntoConstraints = false
        return appWorkingNibView
    }()
    lazy var appNotWorkingView: UIView? = {
        guard let appNotWorkingNibView = getView("AppNotWorkingView") as? AppNotWorkingView else {
            return nil
        }
        appNotWorkingNibView.homeViewControllerDelegate = self
        appNotWorkingNibView.translatesAutoresizingMaskIntoConstraints = false
        appNotWorkingDelegate = appNotWorkingNibView
        return appNotWorkingNibView
    }()
    lazy var appPermissionView: UIView? = {
        guard let appPermissionNibView = getView("AppPermissionView") as? AppPermissionView else {
            return nil
        }
        appPermissionNibView.homeViewControllerDelegate = self
        appPermissionDelegate = appPermissionNibView
        appPermissionNibView.translatesAutoresizingMaskIntoConstraints = false
        return appPermissionNibView
    }()
    lazy var caseHighlightsView: UIView? = {
        guard let caseHighlightsNibView = getView("CaseHighlightsView") as? CaseHighlightsView else {
            return nil
        }
        caseHighlightsNibView.homeViewControllerDelegate = self
        caseHighlightsNibView.translatesAutoresizingMaskIntoConstraints = false
        return caseHighlightsNibView
    }()
    lazy var shareAppButton: UIButton? = {
        let shareAppButton = UIButton()
        shareAppButton.layer.cornerRadius = 10
        shareAppButton.setButton(with: homeSharedApp, and: .secondaryShare, buttonStyle: .secondaryMedium)
        shareAppButton.addTarget(self, action: #selector(shareAppButtonPressed(_:)), for: .touchUpInside)
        shareAppButton.translatesAutoresizingMaskIntoConstraints = false
        return shareAppButton
    }()
    lazy var uploadDataView: UIView? = {
        guard let uploadDataNibView = getView("UploadDataView") as? UploadDataView else {
            return nil
        }
        uploadDataNibView.homeViewControllerDelegate = self
        uploadDataNibView.translatesAutoresizingMaskIntoConstraints = false
        return uploadDataNibView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readPermissionsAndUpdateViews()
        BKLocalizationManager.sharedInstance.loadLocalization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WLAnalytics.sharedInstance()?.send()
        OCLogger.send()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()

        readPermissionsAndUpdateViews()
        observeNotifications()

        updateWhatsNewBadge()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func updateWhatsNewBadge() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[2]

            tabItem.badgeValue = AppData.userHasSeenWhatsNew ? nil : "1"
        }
    }

    private func getView(_ viewName: String) -> UIView? {
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self),
            let view = nib.first as? UIView else {
            return nil
        }
        return view
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        if let appWorkingView = appWorkingView {
            stackView.addArrangedSubview(appWorkingView)
            stackView.setCustomSpacing(0, after: appWorkingView)
        }

        if let appNotWorkingView = appNotWorkingView {
            appNotWorkingView.isVisible = false
            stackView.addArrangedSubview(appNotWorkingView)
            stackView.setCustomSpacing(0, after: appNotWorkingView)
        }

        if let appPermissionView = appPermissionView {
            stackView.addArrangedSubview(appPermissionView)
        }

        if let caseHighlightsView = caseHighlightsView {
            stackView.addArrangedSubview(caseHighlightsView)
        }

        if let shareAppButton = shareAppButton {
            stackView.addArrangedSubview(shareAppButton)
            shareAppButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
            shareAppButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
            shareAppButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        }

        if let uploadDataView = uploadDataView {
            stackView.addArrangedSubview(uploadDataView)
        }

        addBlurStatusBar()
    }

    private func setupLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        localPreferredScreenEdgesDeferringSystemGestures
    }

    func observeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc private
    func applicationDidBecomeActive() {
        readPermissionsAndUpdateViews()
    }

    private func togglePermissionViews() {
        togglePushNotificationsStatusView()
        toggleBluetoothStatusView()
        toggleLocationPermissionStatusView()
    }

    private func readPermissionsAndUpdateViews() {
        blePoweredOn = BluetoothStateManager.shared.isBluetoothOn()
        bleAuthorized = BluetoothStateManager.shared.isBluetoothAuthorized()
        BlueTraceLocalNotifications.shared.checkAuthorization { pnsGranted in
            self.pushNotificationGranted = pnsGranted
            self.locationAuthorized = CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
            self.allPermissionOn = self.blePoweredOn && self.bleAuthorized && self.locationAuthorized
            self.togglePermissionViews()
            self.toggleAppWorking()
        }
    }

    private func toggleAppWorking() {
        appWorkingView?.isVisible = self.allPermissionOn
        appNotWorkingView?.isVisible = !self.allPermissionOn
    }

    private func toggleBluetoothStatusView() {
        appPermissionDelegate?.setBluetoothEnabledStatus(!self.allPermissionOn && !self.blePoweredOn)
        appNotWorkingDelegate?.showHowToEnableBluetooth(self.bleAuthorized && !self.blePoweredOn)
        appNotWorkingDelegate?.showHowToEnableBluetoothPermission(!self.bleAuthorized)
    }

    private func toggleLocationPermissionStatusView () {
        appPermissionDelegate?.setLocationServicesStatus(!self.allPermissionOn && !self.locationAuthorized)
        appNotWorkingDelegate?.showHowToEnableLocationServices(!self.allPermissionOn && !self.locationAuthorized)
    }

    private func togglePushNotificationsStatusView() {
        appPermissionDelegate?.setPushNotificationStatus(!self.pushNotificationGranted)
    }

    private func addBlurStatusBar() {
        let blurryEffect = UIBlurEffect(style: .regular)
        let blurredStatusBar = UIVisualEffectView(effect: blurryEffect)
        blurredStatusBar.translatesAutoresizingMaskIntoConstraints = false
        blurredStatusBar.alpha = 0
        view.addSubview(blurredStatusBar)
        blurredStatusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurredStatusBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurredStatusBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurredStatusBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        blurredStatusBar.transform = CGAffineTransform(translationX: 0, y: -1 * blurredStatusBar.frame.height)
        self.blurredStatusBar = blurredStatusBar
    }

    private func blurStatusBar() {
        guard let blurredStatusBar = blurredStatusBar else {
            return
        }

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                blurredStatusBar.alpha = 0.9
                blurredStatusBar.transform = CGAffineTransform(translationX: 0, y: 0)
            },
            completion: nil
        )
    }

    private func unblurStatusBar() {
        guard let blurredStatusBar = blurredStatusBar else {
            return
        }

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                blurredStatusBar.alpha = 0.0
                blurredStatusBar.transform = CGAffineTransform(translationX: 0, y: -1 * blurredStatusBar.frame.height)
            },
            completion: nil
        )
    }

    @objc
    private func shareAppButtonPressed(_ sender: Any) {
        let shareURL = URL(string: "https://www.example.com/share")
        let activityController = UIActivityViewController(
            activityItems: [
                NSLocalizedString(
                    shareText,
                    tableName: "",
                    bundle: BKLocalizationManager.sharedInstance.currentBundle,
                    value: BKLocalizationManager.sharedInstance.defaultStrings[shareText] ?? "",
                    comment: ""
                ),
                shareURL as Any
            ],
            applicationActivities: nil
        )
        activityController.popoverPresentationController?.sourceView = self.view
        presentViewController(activityController)
    }
}

// MARK: - HomeViewControllerDelegate
extension HomeViewController: HomeViewControllerDelegate {
    func switchTab(_ tabName: TabName) {
        self.tabBarController?.selectedIndex = tabName.tabIndex
    }

    func presentDebugMode() {
        performSegue(withIdentifier: "HomeToDebugSegue", sender: self)
    }
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    func connectToUploadFlow() {
        let uploadViewController = UIStoryboard(name: "UploadData", bundle: nil).instantiateViewController(withIdentifier: "uploadStart")
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = uploadViewController
        }
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 100) {
            unblurStatusBar()
        } else {
            blurStatusBar()
        }
    }
}
