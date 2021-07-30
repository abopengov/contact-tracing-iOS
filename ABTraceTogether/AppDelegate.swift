import BackgroundTasks
import CoreBluetooth
import CoreData
import CoreMotion
import GoogleMaps
import Herald
import IBMMobileFirstPlatformFoundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let onboardingNavigator = OnboardingNavigator(navigationController: UINavigationController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BKLocalizationManager.sharedInstance.setCurrentBundle(forLanguage: Locale.current.languageCode ?? "en")
// Place MFP SSL Certificate in the project
//        WLClient.sharedInstance().pinTrustedCertificatePublicKey(fromFile: "customCertificate.cer")
        WLClient.sharedInstance().registerChallengeHandler(SMSCodeChallengeHandler(securityCheck: SMSCodeChallengeHandler.securityCheck))
        WLAnalytics.sharedInstance().addDeviceEventListener(LIFECYCLE)
        WLAnalytics.sharedInstance().send()
        OCLogger.setLevel(OCLogger_ERROR)
        OCLogger.setCapture(true)
        // configure the database manager
        self.configureDatabaseManager()
        BlueTraceLocalNotifications.shared.initialConfiguration()

        setupHerald()

        PauseScheduler.shared.setup()

        GMSServices.provideAPIKey(googleMapsApiKey)

        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.DLog("applicationDidBecomeActive")

        SettingsBundleHelper.setVersionAndBuildNumber()
        if (!FairEfficacyInstrumentation.shared.enabled) {
            checkIfAppRegistered()
            UrlsRepository().getAllUrlsAndPersist()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.DLog("applicationWillEnterForeground")

        BluetraceUtils.removeData21DaysOld()

        BlueTraceLocalNotifications.shared.removePendingNotificationRequests()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Logger.DLog("applicationWillTerminate")
    }

    // MARK: Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "tracer")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

// MARK: - helpers
extension AppDelegate {
    func blockAppUsage() {
        // show gray background to cover whole screen
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        for subview in window.subviews {
            if subview.tag == Tag.tagOne.tagNumber || subview.tag == Tag.tagTwo.tagNumber {
                subview.removeFromSuperview()
            }
        }
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.tag = Tag.tagOne.tagNumber
        window.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.alpha = 0.85
        let alertBackgroundView = UIView()
        alertBackgroundView.tag = Tag.tagTwo.tagNumber
        alertBackgroundView.backgroundColor = UIColor.white
        alertBackgroundView.cornerRadius = 10
        window.addSubview(alertBackgroundView)
        alertBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        alertBackgroundView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        alertBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundView.leadingAnchor, constant: 20).isActive = true
        alertBackgroundView.trailingAnchor.constraint(greaterThanOrEqualTo: backgroundView.trailingAnchor, constant: -20).isActive = true
        alertBackgroundView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.setLabel(
            with: killSwitchMessageString,
            using: .body
        )
        label.numberOfLines = 0
        alertBackgroundView.addSubview(label)
        label.leadingAnchor.constraint(greaterThanOrEqualTo: alertBackgroundView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(greaterThanOrEqualTo: alertBackgroundView.trailingAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        self.onboardingNavigator.welcomeCompleted = false
        HeraldManager.shared.stop()
    }
}

// MARK: - Network Calls
extension AppDelegate {
    func checkIfAppRegistered() {
        let registerPhoneURLString = registeredApi
        guard let registerPhoneUrl = URL(string: registerPhoneURLString),
            let wlResourceRequest = WLResourceRequest(
                url: registerPhoneUrl,
                method: getMethodString
            ) else {
            return
        }
        wlResourceRequest.send { [weak self] response, _ -> Void in
            if (response?.responseJSON as? [String: Any])?[errorCodeString] as? String == noExistingAppString {
                self?.blockAppUsage()
            }
        }
    }
}

// MARK: - Core Data Saving support
extension AppDelegate {
    func configureDatabaseManager() {
        DatabaseManager.shared().persistentContainer = self.persistentContainer
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Herald Setup
extension AppDelegate {
    private func setupHerald() {
        if !BluetoothStateManager.shared.isBluetoothAuthorized() {
            Logger.DLog("Bluetooth is not authorized. Herald not started.")
        } else if !onboardingNavigator.successCompleted {
            Logger.DLog("Onboarding not yet done. Herald not started.")
        } else if PauseScheduler.shared.withinPauseSchedule {
            Logger.DLog("Detection is paused. Herald not started.")
        } else {
            HeraldManager.shared.start()
        }

        EncounterMessageManager.shared.setup()
    }
}

// Google Maps
extension AppDelegate {
    private var googleMapsApiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "AppProperties", ofType: "plist") else {
                Logger.DLog("Couldn't find file AppProperties")
                return ""
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "MAPS_API_KEY") as? String else {
                Logger.DLog("Couldn't find MAPS_API_KEY from AppProperties.plist")
                return ""
            }

            return value
        }
    }
}

// Pause
extension AppDelegate {
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Logger.DLog("performFetchWithCompletionHandler")

        PauseScheduler.shared.togglePause()

        completionHandler(.newData)
    }
}
