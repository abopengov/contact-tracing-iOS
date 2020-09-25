import UIKit
import CoreData
import IBMMobileFirstPlatformFoundation
import Lottie

class HomeViewController: UIViewController {

    @IBOutlet weak var screenStack: UIStackView!
    @IBOutlet weak var bluetoothStatusOffView: UIView!
    @IBOutlet weak var bluetoothStatusOnView: UIView!
    @IBOutlet weak var bluetoothPermissionOffView: UIView!
    @IBOutlet weak var bluetoothPermissionOnView: UIView!
    @IBOutlet weak var pushNotificationOnView: UIView!
    @IBOutlet weak var pushNotificationOffView: UIView!
    @IBOutlet weak var incompleteHeaderView: UIView!
    @IBOutlet weak var successHeaderView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var appPermissionsLabelView: UIView!
    @IBOutlet weak var powerSaverCardView: UIView!
    @IBOutlet weak var conserveBatteryView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var shareViewHeaderLabel: UILabel!
    @IBOutlet weak var shareViewDetailLabel: UILabel!
        
    @IBOutlet weak var powerSaverCardViewHeaderLabel: UILabel!
    @IBOutlet weak var powerSaverCardViewDetailLabel: UILabel!
    
    @IBOutlet weak var appPermissionsLabel: UILabel!
    
    @IBOutlet weak var bluetoothPermissionOnViewLabel: UILabel!
    @IBOutlet weak var bluetoothPermissionOnViewImageView: UIImageView!
    
    @IBOutlet weak var bluetoothStatusOnViewLabel: UILabel!
    @IBOutlet weak var bluetoothStatusOnViewImageView: UIImageView!
    
    @IBOutlet weak var pushNotificationOnViewLabel: UILabel!
    @IBOutlet weak var pushNotificationOnViewImageView: UIImageView!
    
    @IBOutlet weak var headerMessageLabel: UILabel!
    @IBOutlet weak var logoTextLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var appPermissionStatusInfoButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var fetchedResultsController: NSFetchedResultsController<Encounter>?

    var allPermissionOn = true
    var bleAuthorized = true
    var blePoweredOn = true
    var pushNotificationGranted = true
//    var remoteConfig = RemoteConfig.remoteConfig()

    var _preferredScreenEdgesDeferringSystemGestures: UIRectEdge = []

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return _preferredScreenEdgesDeferringSystemGestures
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.setLabel(with: "Help stop the spread \nof COVID-19", using: .h2)
        headerLabel.textAlignment = .left
        
        logoTextLabel.setLabel(with: "Brought to you by the", using: .eyebrowText)
        
        shareViewHeaderLabel.setLabel(with: "Share this app",
                                      using: .h2)
        shareViewDetailLabel.setLabel(with: "Help flatten the curve faster: invite your  family and friends to use the app.",
                                      using: .body)
        shareViewDetailLabel.textAlignment = .left

        powerSaverCardViewHeaderLabel.setLabel(with: "Physical distancing makes a big difference.",
                                      using: .h2)
        powerSaverCardViewHeaderLabel.textAlignment = .left
        
        powerSaverCardViewDetailLabel.setLabel(with: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially",
                                      using: .body)
        powerSaverCardViewDetailLabel.textAlignment = .left
        
        powerSaverCardView.backgroundColor = .white
        
        appPermissionsLabel.setLabel(with: "App Permissions status",
                                     using: .h2)
        appPermissionsLabel.textAlignment = .left
        
        headerMessageLabel.setLabel(with: "by keeping your Bluetooth on while the app is running with your phone locked or unlocked, especially when you are out, on public transport, at work, or in public places.", using: .body)
        headerMessageLabel.textAlignment = .left
        
        if let appVersion = UIApplication.appVersion {
            versionLabel.setLabel(with: "Version: \(appVersion) \(getVersionIdentifierForEnvironment())",
                                 using: .body)
            versionLabel.textAlignment = .left
            versionLabel.isHidden = false
        } else {
            versionLabel.isHidden = true
        }
        
        observeNotifications()

        animationView.loopMode = LottieLoopMode.playOnce
        self.playActivityAnimation()
    }

    private func getVersionIdentifierForEnvironment() -> String {
           let devString = "mfpdev"
           let stagingString = "mfpstg"

           guard let urlHostString = WLResourceRequest(url: URL(string: "/adapters"), method: "GET")?.url.host else {
               return ""
           }

           if urlHostString.contains(stagingString) {
               return "S"
           } else if urlHostString.contains(devString) {
               return "D"
           }
           
           return ""
           
       }

    func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableDeferringSystemGestures(_:)), name: .enableDeferringSystemGestures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableDeferringSystemGestures(_:)), name: .disableDeferringSystemGestures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableUserInteraction(_:)), name: .disableUserInteraction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableUserInteraction(_:)), name: .enableUserInteraction, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readPermissionsAndUpdateViews()
        self.fetchEncounters()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WLAnalytics.sharedInstance()?.send()
        OCLogger.send()
    }
    
    @objc private func applicationDidBecomeActive() {
        readPermissionsAndUpdateViews()
    }

    private func togglePermissionViews() {
        togglePushNotificationsStatusView()
        toggleBluetoothStatusView()
        toggleBluetoothPermissionStatusView()
        toggleIncompleteHeaderView()
    }

    private func readPermissionsAndUpdateViews() {

        blePoweredOn = BluetraceManager.shared.isBluetoothOn()
        bleAuthorized = BluetraceManager.shared.isBluetoothAuthorized()
        BlueTraceLocalNotifications.shared.checkAuthorization { (pnsGranted) in
            self.pushNotificationGranted = pnsGranted
            self.allPermissionOn = self.blePoweredOn && self.bleAuthorized && self.pushNotificationGranted

            self.togglePermissionViews()
        }
    }

    private func toggleIncompleteHeaderView() {
//        successHeaderView.isVisible = self.allPermissionOn
//        powerSaverCardView.isVisible = self.allPermissionOn
//        incompleteHeaderView.isVisible = !self.allPermissionOn
//        appPermissionsLabel.isVisible = !self.allPermissionOn
    }

    private func toggleBluetoothStatusView() {
        bluetoothStatusOnViewLabel.textAlignment = .left
        if !self.allPermissionOn && !self.blePoweredOn {
            //bluetooth power off
            bluetoothStatusOnViewLabel.setLabel(with: "Bluetooth Enabled: No", using: .body)
            bluetoothStatusOnViewImageView.image = UIImage(named: "StatusIconOff")
        } else {
            bluetoothStatusOnViewLabel.setLabel(with: "Bluetooth Enabled: Yes", using: .body)
            bluetoothStatusOnViewImageView.image = UIImage(named: "StatusIconOn")
        }
    }

    private func toggleBluetoothPermissionStatusView() {
        bluetoothPermissionOnViewLabel.textAlignment = .left
        if !self.allPermissionOn && !self.bleAuthorized {
            //permission power off
            bluetoothPermissionOnViewLabel.setLabel(with: "Permissions Enabled: No", using: .body)
            bluetoothPermissionOnViewImageView.image = UIImage(named: "StatusIconOff")
        } else {
            bluetoothPermissionOnViewLabel.setLabel(with: "Permissions Enabled: Yes", using: .body)
            bluetoothPermissionOnViewImageView.image = UIImage(named: "StatusIconOn")
        }
    }

    private func togglePushNotificationsStatusView() {
        pushNotificationOnViewLabel.textAlignment = .left
        if !self.allPermissionOn && !self.pushNotificationGranted {
            //pushNotificatio power on
            pushNotificationOnViewLabel.setLabel(with: "Push Notifications: No", using: .body)
            pushNotificationOnViewImageView.image = UIImage(named: "StatusIconOff")
        } else {
            pushNotificationOnViewLabel.setLabel(with: "Push Notifications: Yes", using: .body)
            pushNotificationOnViewImageView.image = UIImage(named: "StatusIconOn")
        }
    }

    @IBAction func appPermissionStatusInfoButtonPressed(_ sender: Any) {
        #if DEBUG
            self.performSegue(withIdentifier: "HomeToDebugSegue", sender: self)
        #else
        let errorAlert = UIAlertController(title: "Permission Information",
                                           message: "Your app permissions need to be on for to work. If they’re off, please go to your device settings and turn them on.", preferredStyle: .alert)
              errorAlert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "Default action"), style: .default, handler: { _ in
              }))
              self.present(errorAlert, animated: true)
        #endif
    }
    
    @IBAction func optimizeTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showOptimizeSegue", sender: self)
    }
    
    @IBAction func onHeroTapped(_ sender: UITapGestureRecognizer) {
        Logger.DLog("tapped")
        #if DEBUG
        self.performSegue(withIdentifier: "HomeToDebugSegue", sender: self)
        #endif
    }

    @IBAction func onShareTapped(_ sender: UITapGestureRecognizer) {
        #if DEBUG
        uploadFile(token: "ckTest") { (done) in
            print("uploadDOne")
        }
        #else
        let shareText = "I am using to combat COVID-19! Download it from the Apple App Store or Google Play to join the fight. Find more information on the link below."
        let shareURL = URL(string: "https://www.yourAppLink.com")
        let activityController = UIActivityViewController(activityItems: [shareText, shareURL as Any], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = shareView
        present(activityController, animated: true, completion: nil)
        #endif
    }

    @IBAction func onPowerSaverButtonTapped(_ sender: Any) {

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
            _preferredScreenEdgesDeferringSystemGestures = .bottom
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    @objc
    func disableDeferringSystemGestures(_ notification: Notification) {
        if #available(iOS 11.0, *) {
            _preferredScreenEdgesDeferringSystemGestures = []
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }

    func fetchEncounters() {
        let sortByDate = NSSortDescriptor(key: "timestamp", ascending: false)

        fetchedResultsController = DatabaseManager.shared().getFetchedResultsController(Encounter.self, with: nil, with: sortByDate, prefetchKeyPaths: nil, delegate: self)

        do {
            try fetchedResultsController?.performFetch()
            setInitialLastUpdatedTime()
        } catch let error as NSError {
            print("Could not perform fetch. \(error), \(error.userInfo)")
        }

    }

    func setInitialLastUpdatedTime() {
        guard let encounters = fetchedResultsController?.fetchedObjects else {
            return
        }
        guard encounters.count > 0 else {
            return
        }
        let firstEncounter = encounters[0]
        updateLastUpdatedTime(date: firstEncounter.timestamp!)
    }

    func updateLastUpdatedTime(date: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        lastUpdatedLabel.text = "Last updated: \(formatter.string(from: date))"
    }
    
    func playActivityAnimation() {
         animationView.play()
     }
}

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

//MARK: - using this to export log to file for dev purpose, This will not be part of the release build
extension HomeViewController: UIDocumentInteractionControllerDelegate {
     func uploadFile(token: String, _ result: @escaping (Bool) -> Void) {
                let manufacturer = "Apple"
                let model = DeviceInfo.getModel().replacingOccurrences(of: " ", with: "")

                let date: Date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
                let todayDate = dateFormatter.string(from: date)

                let file = "StreetPassRecord_\(manufacturer)_\(model)_\(todayDate).json"

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }

                let managedContext = appDelegate.persistentContainer.viewContext

                let recordsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForRecords()
                let eventsFetchRequest: NSFetchRequest<Encounter> = Encounter.fetchRequestForEvents()

                managedContext.perform { [unowned self] in
                    guard let records = try? recordsFetchRequest.execute() else {
                        Logger.DLog("Error fetching records")
                        result(false)
                        return
                    }

                    guard let events = try? eventsFetchRequest.execute() else {
                        Logger.DLog("Error fetching events")
                        result(false)
                        return
                    }

                    let data = UploadFileData(token: token, records: records, events: events)

                    let encoder = JSONEncoder()
                    guard let json = try? encoder.encode(data) else {
                        Logger.DLog("Error serializing data")
                        result(false)
                        return
                    }

                    guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        Logger.DLog("Error locating user documents directory")
                        result(false)
                        return
                    }

                    let fileURL = directory.appendingPathComponent(file)

                    do {
                        try json.write(to: fileURL, options: [])
                        let controller = UIDocumentInteractionController(url: fileURL)
                        controller.delegate = self
                        controller.presentPreview(animated: true)
                    } catch {
                        Logger.DLog("Error writing to file")
                        result(false)
                        return
                    }
                }
            }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
