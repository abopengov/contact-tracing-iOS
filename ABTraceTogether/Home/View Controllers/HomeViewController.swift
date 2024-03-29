// swiftlint:disable file_length
import CoreData
import CoreLocation
import IBMMobileFirstPlatformFoundation
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
    private var statsRepository: StatsRepository?
    private var urlsRepository: UrlsRepository?

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
    lazy var guidanceView: GuidanceView? = {
        guard let guidanceNibView = getView("GuidanceView") as? GuidanceView else {
            return nil
        }

        guidanceNibView.homeViewControllerDelegate = self
        guidanceNibView.translatesAutoresizingMaskIntoConstraints = false
        return guidanceNibView
    }()
    lazy var appPausedView: AppPausedView? = {
        guard let appPausedNibView = getView("AppPausedView") as? AppPausedView else {
            return nil
        }
        appPausedNibView.homeViewControllerDelegate = self
        appPausedNibView.translatesAutoresizingMaskIntoConstraints = false
        return appPausedNibView
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
    lazy var homeStatsView: HomeStatsView? = {
        guard let homeStatsNibView = getView("HomeStatsView") as? HomeStatsView else {
            return nil
        }
        homeStatsNibView.homeViewControllerDelegate = self
        homeStatsNibView.translatesAutoresizingMaskIntoConstraints = false
        return homeStatsNibView
    }()
    lazy var shareAppView: ShareAppView? = {
        guard let shareAppNibView = getView("ShareAppView") as? ShareAppView else {
            return nil
        }
        shareAppNibView.homeViewControllerDelegate = self
        shareAppNibView.translatesAutoresizingMaskIntoConstraints = false
        return shareAppNibView
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
        self.updateGuidanceBanner()
        self.updateHomeStats()
        BKLocalizationManager.sharedInstance.loadLocalization()
        PauseScheduler.shared.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WLAnalytics.sharedInstance()?.send()
        OCLogger.send()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        statsRepository = StatsRepository()
        urlsRepository = UrlsRepository()

        setupViews()
        setupLayout()

        readPermissionsAndUpdateViews()
        observeNotifications()

        updateWhatsNewBadge()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        PauseScheduler.shared.delegate = nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func updateGuidanceBanner() {
        urlsRepository?.getGuidanceTile { guidanceTile in
            if let guidanceTile = guidanceTile,
               let title = guidanceTile.title,
               let text = guidanceTile.text {
                self.guidanceView?.title = title
                self.guidanceView?.text = text
                self.guidanceView?.link = guidanceTile.link ?? guidanceLink
                self.guidanceView?.isHidden = false
            } else {
                self.guidanceView?.isHidden = true
            }
        }
    }

    private func updateHomeStats() {
        statsRepository?.getHomeStats { homeStats in
            if let homeStats = homeStats {
                self.homeStatsView?.setHomeStats(homeStats)
            }
        }
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

        if let appPausedView = appPausedView {
            appPausedView.isVisible = false
            stackView.addArrangedSubview(appPausedView)
            stackView.setCustomSpacing(0, after: appPausedView)
        }

        if let appPermissionView = appPermissionView {
            stackView.addArrangedSubview(appPermissionView)
        }

        if let guidanceView = guidanceView {
            stackView.addArrangedSubview(guidanceView)
            stackView.setCustomSpacing(20, after: guidanceView)
            guidanceView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
            guidanceView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
            guidanceView.isVisible = false
        }

        if let homeStatsView = homeStatsView {
            stackView.addArrangedSubview(homeStatsView)
        }

        if let shareAppView = shareAppView {
            stackView.addArrangedSubview(shareAppView)
            shareAppView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
            shareAppView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
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

    @objc
    private func applicationDidBecomeActive() {
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
            self.updateAppWorkingViews()
        }
    }

    private func updateAppWorkingViews() {
        let detectionPaused = PauseScheduler.shared.withinPauseSchedule
        appWorkingView?.isVisible = self.allPermissionOn && !detectionPaused
        appNotWorkingView?.isVisible = !self.allPermissionOn && !detectionPaused
        appPausedView?.isVisible = detectionPaused
        appPausedView?.updatePauseEndTime()
        appPermissionView?.isVisible = !detectionPaused
        homeStatsView?.setColorStyle(detectionPaused ? .purple : .blue)
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
        let shareURL = URL(string: "https://example.com/share")
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

        if let navVC = self.tabBarController?.selectedViewController as? UINavigationController {
            if let rootVC = navVC.viewControllers.first {
                navVC.viewControllers = [rootVC]
            }
        }
    }

    func switchTab(_ tabName: TabName, segueName: String) {
        switchTab(tabName)

        if let navVC = self.tabBarController?.selectedViewController as? UINavigationController {
            if let selectedVC = navVC.viewControllers.first {
                selectedVC.performSegue(withIdentifier: segueName, sender: selectedVC)
            }
        }
    }

    func presentDebugMode() {
        performSegue(withIdentifier: "HomeToDebugSegue", sender: self)
    }

    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func openUploadFlow() {
        let uploadViewController = UIStoryboard(name: "UploadData", bundle: nil).instantiateViewController(withIdentifier: "uploadStart")
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = uploadViewController
        }
    }

    func openPauseDetection() {
        let pauseViewController = UIStoryboard(name: "Pause", bundle: nil).instantiateViewController(withIdentifier: "pauseStart")
        pauseViewController.modalPresentationStyle = .fullScreen
        present(pauseViewController, animated: true, completion: nil)
    }

    func refreshHomeScreen() {
        self.updateAppWorkingViews()
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

// MARK: - PauseSchedulerDelegate
extension HomeViewController: PauseSchedulerDelegate {
    func pauseToggled() {
        readPermissionsAndUpdateViews()
    }
}
