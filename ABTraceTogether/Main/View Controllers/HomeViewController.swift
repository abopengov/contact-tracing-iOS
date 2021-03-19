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
    weak var appPermissionDelegate: AppPermissionDelegate?
    weak var headerViewDelegate: HeaderViewDelegate?
    weak var caseSummaryViewDelegate: CaseSummaryViewDelegate?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = homeScreenBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = homeScreenBackgroundColor
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = homeScreenBackgroundColor
        return view
    }()

    var headerView: UIView? {
        guard let headerNibView = getView("HeaderView") as? HeaderView else {
            return nil
        }
        headerViewDelegate = headerNibView
        headerNibView.translatesAutoresizingMaskIntoConstraints = false
        headerNibView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return headerNibView
    }
    var uploadDataView: UIView? {
        guard let uploadDataNibView = getView("UploadDataView") as? UploadDataView else {
            return nil
        }
        uploadDataNibView.homeViewControllerDelegate = self
        uploadDataNibView.translatesAutoresizingMaskIntoConstraints = false
        uploadDataNibView.heightAnchor.constraint(equalToConstant: 290).isActive = true
        return uploadDataNibView
    }

    var caseSummaryView: UIView? {
        guard let caseSummaryNibView = getView("CaseSummaryView") as? CaseSummaryView else {
            return nil
        }

        var caseSummaryWebViewHeight: CGFloat?
        if let height = UserDefaults.standard.object(forKey: "caseSummaryWebViewKey") as? Int {
            caseSummaryWebViewHeight = CGFloat(height + 100)
        }

        caseSummaryViewDelegate = caseSummaryNibView
        caseSummaryNibView.homeViewControllerDelegate = self
        caseSummaryNibView.translatesAutoresizingMaskIntoConstraints = false
        caseSummaryNibView.backgroundColor = homeScreenBackgroundColor
        caseSummaryNibView.heightAnchor.constraint(equalToConstant: caseSummaryWebViewHeight ?? 600).isActive = true
        caseSummaryNibView.tag = 99
        return caseSummaryNibView
    }

    var appPermissionView: UIView? {
        guard let appPermissionNibView = getView("AppPermissionView") as? AppPermissionView else {
            return nil
        }
        appPermissionNibView.homeViewControllerDelegate = self
        appPermissionDelegate = appPermissionNibView
        appPermissionNibView.translatesAutoresizingMaskIntoConstraints = false
        appPermissionNibView.backgroundColor = .clear
        appPermissionNibView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return appPermissionNibView
    }

    var messageView: UIView? {
        guard let messageNibView = getView("MessageView") as? MessageView else {
            return nil
        }

        messageNibView.translatesAutoresizingMaskIntoConstraints = false
        messageNibView.backgroundColor = homeScreenBackgroundColor
        messageNibView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        return messageNibView
    }

    var shareAppView: UIView? {
        guard let shareAppNibView = getView("ShareAppView") as? ShareAppView else {
            return nil
        }
        shareAppNibView.homeViewControllerDelegate = self
        shareAppNibView.translatesAutoresizingMaskIntoConstraints = false
        shareAppNibView.backgroundColor = homeScreenBackgroundColor
        shareAppNibView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return shareAppNibView
    }

    var broughtToYouByView: UIView? {
        guard let broughtToYouByNibView = getView("BroughtToYouByView") as? BroughtToYouByView else {
            return nil
        }
        broughtToYouByNibView.translatesAutoresizingMaskIntoConstraints = false
        broughtToYouByNibView.backgroundColor = homeScreenBackgroundColor
        broughtToYouByNibView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return broughtToYouByNibView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readPermissionsAndUpdateViews()
        self.fetchEncounters()
        BKLocalizationManager.sharedInstance.loadLocalization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WLAnalytics.sharedInstance()?.send()
        OCLogger.send()
        if let webViewUrl = BKLocalizationManager.sharedInstance.dynamicUrl?.home {
            reloadWebView(webViewUrl)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()

        readPermissionsAndUpdateViews()
        observeNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func getView(_ viewName: String) -> UIView? {
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self),
            let view = nib.first as? UIView else {
            return nil
        }
        return view
    }

    private func setupViews() {
        scrollView.backgroundColor = .lightGray
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        if let headerView = headerView {
            stackView.addArrangedSubview(headerView)
        }

        if let caseSummaryView = caseSummaryView as? CaseSummaryView {
            stackView.addArrangedSubview(caseSummaryView)
            hideCaseSummaryView(caseSummaryView.caseSummaryURLString == nil)
        }

        if let appPermissionView = appPermissionView {
            stackView.addArrangedSubview(appPermissionView)
        }

        if let uploadDataView = uploadDataView {
            stackView.addArrangedSubview(uploadDataView)
        }

        if let messageView = messageView {
            stackView.addArrangedSubview(messageView)
        }

        if let shareAppView = shareAppView {
            stackView.addArrangedSubview(shareAppView)
        }

        if let broughtToYouByView = broughtToYouByView {
            stackView.addArrangedSubview(broughtToYouByView)
        }
    }

    func hideCaseSummaryView(_ hide: Bool) {
        DispatchQueue.main.async {
            // swiftlint:disable:next trailing_closure
            self.stackView
                .subviews
                .first(
                    where: {
                        $0.tag == 99
                    }
                )?.isHidden = hide
            self.stackView.layoutIfNeeded()
        }
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableDeferringSystemGestures(_:)),
            name: .enableDeferringSystemGestures,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disableDeferringSystemGestures(_:)),
            name: .disableDeferringSystemGestures,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disableUserInteraction(_:)),
            name: .disableUserInteraction,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableUserInteraction(_:)),
            name: .enableUserInteraction,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshWebView(_:)),
            name: Notification.Name("urlFetched"),
            object: nil
        )
    }

    @objc
    func refreshWebView(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String],
            let url = data[caseSummaryKey] {
            reloadWebView(url)
        }
    }

    private func reloadWebView(_ urlString: String) {
        caseSummaryViewDelegate?.updateCaseSummaryView(urlString)
    }

    @objc private
    func applicationDidBecomeActive() {
        readPermissionsAndUpdateViews()
    }

    private func togglePermissionViews() {
        togglePushNotificationsStatusView()
        toggleBluetoothStatusView()
        toggleBluetoothPermissionStatusView()
        toggleLocationPermissionStatusView()
    }

    private func readPermissionsAndUpdateViews() {
        blePoweredOn = BluetoothStateManager.shared.isBluetoothOn()
        bleAuthorized = BluetoothStateManager.shared.isBluetoothAuthorized()
        BlueTraceLocalNotifications.shared.checkAuthorization { pnsGranted in
            self.pushNotificationGranted = pnsGranted
            self.locationAuthorized = CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
            self.allPermissionOn = self.blePoweredOn && self.bleAuthorized && self.pushNotificationGranted && self.locationAuthorized
            self.togglePermissionViews()
        }
    }

    private func toggleBluetoothStatusView() {
        appPermissionDelegate?.setBlueToothEnabledStatus(!self.allPermissionOn && !self.blePoweredOn)
    }

    private func toggleBluetoothPermissionStatusView() {
        appPermissionDelegate?.setPermisttionStatus(!self.allPermissionOn && !self.bleAuthorized)
    }

    private func toggleLocationPermissionStatusView () {
        appPermissionDelegate?.setLocationServicesStatus(!self.allPermissionOn && !self.locationAuthorized)
    }

    private func togglePushNotificationsStatusView() {
        appPermissionDelegate?.setPushNotificationStatus(!self.allPermissionOn && !self.pushNotificationGranted)
    }

    @objc
    func enableUserInteraction(_ notification: Notification) {
        self.view.isUserInteractionEnabled = true
    }

    @objc
    func disableUserInteraction(_ notification: Notification) {
        self.view.isUserInteractionEnabled = false
    }

    @objc
    func enableDeferringSystemGestures(_ notification: Notification) {
        if #available(iOS 11.0, *) {
            localPreferredScreenEdgesDeferringSystemGestures = .bottom
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    @objc
    func disableDeferringSystemGestures(_ notification: Notification) {
        if #available(iOS 11.0, *) {
            localPreferredScreenEdgesDeferringSystemGestures = []
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    func fetchEncounters() {
        let sortByDate = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchedResultsController = DatabaseManager.shared().getFetchedResultsController(
            Encounter.self,
            with: nil,
            with: sortByDate,
            prefetchKeyPaths: nil,
            delegate: self
        )
        do {
            try fetchedResultsController?.performFetch()
            setInitialLastUpdatedTime()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }
    }

    func setInitialLastUpdatedTime() {
        guard let firstEncounterDate = fetchedResultsController?.fetchedObjects?.first?.timestamp else {
            return
        }
        updateLastUpdatedTime(date: firstEncounterDate)
    }

    func updateLastUpdatedTime(date: Date) {
        headerViewDelegate?.updateLastUpdatedTime(date)
    }

    func playActivityAnimation() {
        headerViewDelegate?.playAnimation()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let encounter = anObject as! Encounter
            if ![Encounter.Event.scanningStarted.rawValue, Encounter.Event.scanningStopped.rawValue].contains(encounter.msg) {
                self.playActivityAnimation()
            }
            self.updateLastUpdatedTime(date: Date())
            break

        default:

            self.updateLastUpdatedTime(date: Date())
            break
        }
    }
}

// MARK: - HomeViewControllerDelegate
extension HomeViewController: HomeViewControllerDelegate {
    func switchTab(_ tabName: TabName) {
        self.tabBarController?.selectedIndex = tabName.tabIndex
    }

    func presentDebugMode(_ identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
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
