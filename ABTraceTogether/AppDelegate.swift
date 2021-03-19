import CoreBluetooth
import CoreData
import CoreMotion
import Herald
import IBMMobileFirstPlatformFoundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var pogoMM: PogoMotionManager!

    let onboardingNavigator = OnboardingNavigator(navigationController: UINavigationController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BKLocalizationManager.sharedInstance.setCurrentBundle(forLanguage: Locale.current.languageCode ?? "en")
        //Enable this to pin own certificate
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

        // setup pogo mode
        pogoMM = PogoMotionManager(window: self.window)
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.DLog("applicationDidBecomeActive")
        pogoMM.startAccelerometerUpdates()
        SettingsBundleHelper.setVersionAndBuildNumber()
        if (!FairEfficacyInstrumentation.shared.enabled) {
            checkIfAppRegistered()
            getAllUrls(Locale.current.languageCode ?? "en")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.DLog("applicationWillEnterForeground")
        pogoMM.stopAllMotion()
        BluetraceUtils.removeData21DaysOld()

        BlueTraceLocalNotifications.shared.removePendingNotificationRequests()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Logger.DLog("applicationWillTerminate")
        pogoMM.stopAllMotion()
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

// MARK: - App Url
extension AppDelegate {
    func getAllUrls(_ language: String) {
        let getStatisticsUrlString = getUrlsApi
        guard let getStatisticsUrl = URL(string: getStatisticsUrlString) else {
            Logger.logError(with: "Get Urls error. Error converting from getStatisticsUrlString to URL: \(getStatisticsUrlString)")
            return
        }
        guard let wlResourceRequest = WLResourceRequest(
            url: getStatisticsUrl,
            method: getMethodString
        ) else {
            Logger.logError(with: "Get Urls error. Error converting to wlResourceRequest. \(getStatisticsUrl)")
            return
        }
        wlResourceRequest.queryParameters = ["lang": language]
        wlResourceRequest.send {response, error -> Void  in
            if let error = error {
                Logger.logError(with: "\(error)")
            }
            guard let data = response?.responseData else {
                return
            }
            do {
                let dynamicUrl = try JSONDecoder().decode(DynamicUrl.self, from: data)
                UserDefaults.standard.set(dynamicUrl.guidance, forKey: guidanceKey)
                UserDefaults.standard.set(dynamicUrl.stats, forKey: statisticsKey)
                UserDefaults.standard.set(dynamicUrl.faq, forKey: faqUrlKey)
                UserDefaults.standard.set(dynamicUrl.privacy, forKey: privacyUrlKey)
                UserDefaults.standard.set(dynamicUrl.mhr, forKey: mhrKey)
                UserDefaults.standard.set(dynamicUrl.gis, forKey: gisKey)
                UserDefaults.standard.set(dynamicUrl.helpEmail, forKey: helpEmailKey)
                NotificationCenter.default.post(
                    name: Notification.Name(notificationNameUrl),
                    object: nil,
                    userInfo: [caseSummaryKey: dynamicUrl.home]
                )
                BKLocalizationManager.sharedInstance.dynamicUrl = dynamicUrl
            } catch {}
        }
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
        if onboardingNavigator.successCompleted && BluetoothStateManager.shared.isBluetoothAuthorized() {
            HeraldManager.shared.start()
        } else {
            Logger.DLog("Onboarding not yet done.")
        }

        EncounterMessageManager.shared.setup()
    }
}
