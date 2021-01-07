import UIKit
import CoreData
import CoreMotion
import IBMMobileFirstPlatformFoundation
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var pogoMM: PogoMotionManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Enable this to pin own certificate
//        WLClient.sharedInstance().pinTrustedCertificatePublicKey(fromFile: "customCertificate.cer")
        WLClient.sharedInstance().registerChallengeHandler(SMSCodeChallengeHandler(securityCheck: SMSCodeChallengeHandler.securityCheck))
        WLAnalytics.sharedInstance().addDeviceEventListener(LIFECYCLE)
        WLAnalytics.sharedInstance().send()
        OCLogger.setLevel(OCLogger_ERROR)
        OCLogger.setCapture(true);
        
        //configure the database manager
        self.configureDatabaseManager()

        //the below can be in a single configure method inside the BluetraceManager
        let bluetoothAuthorised = BluetraceManager.shared.isBluetoothAuthorized()
        if  OnboardingManager.shared.completedBluetoothOnboarding && bluetoothAuthorised {
            BluetraceManager.shared.turnOn()
            if !LocationManager.shared.isLocationAuthorized() {
                LocationManager.shared.turnOn()
                LocationManager.shared.start()
            } else {
                LocationManager.shared.start()
            }

        } else {
            print("Onboarding not yet done.")
        }

        EncounterMessageManager.shared.setup()
        UIApplication.shared.isIdleTimerDisabled = true

        BlueTraceLocalNotifications.shared.initialConfiguration()

        // setup pogo mode
        pogoMM = PogoMotionManager(window: self.window)

        navigateToCorrectPage()

        return true
    }
    
    func checkIfAppRegistered() {
        let registerPhoneURLString = "/adapters/smsOtpService/phone/isRegistered"
        guard let registerPhoneUrl = URL(string: registerPhoneURLString) ,
            let wlResourceRequest = WLResourceRequest(url: registerPhoneUrl, method:"GET") else {
            return
        }
        
        wlResourceRequest.send(completionHandler: { [weak self] (response, error) -> Void in
            if (response?.responseJSON as? [String:Any])?["errorCode"] as? String == "APPLICATION_DOES_NOT_EXIST" {
                
                //show gray background to cover whole screen
                let window = UIApplication.shared.keyWindow!
                for subview in window.subviews {
                    if subview.tag == 99 || subview.tag == 98 {
                           subview.removeFromSuperview()
                    }
                }
                let backgroundView = UIView(frame: window.bounds)
                backgroundView.tag = 99
                window.addSubview(backgroundView);
                backgroundView.backgroundColor = UIColor.gray
                backgroundView.alpha = 0.85
                
                
                let alertBackgroundView = UIView()
                alertBackgroundView.tag = 98
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
                label.setLabel(with: "The version of the App you are trying to access has been updated. Download the latest version from the App Store. For additional details please refer to the FAQs", using: .body)
                label.numberOfLines = 0
                alertBackgroundView.addSubview(label)
                
                label.leadingAnchor.constraint(greaterThanOrEqualTo: alertBackgroundView.leadingAnchor, constant: 20).isActive = true
                label.trailingAnchor.constraint(greaterThanOrEqualTo: alertBackgroundView.trailingAnchor, constant: -20).isActive = true
                label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
                
                OnboardingManager.shared.completedIWantToHelp = false
                self?.navigateToCorrectPage()
                BluetraceManager.shared.toggleScanning(false)
                BluetraceManager.shared.toggleAdvertisement(false)
            }
        })
    }

    func navigateToCorrectPage() {
        let navController = self.window!.rootViewController! as! UINavigationController
        let storyboard = navController.storyboard!

        let launchVCIdentifier = OnboardingManager.shared.returnCurrentLaunchPage()
        let vc = storyboard.instantiateViewController(withIdentifier: launchVCIdentifier)
        navController.setViewControllers([vc], animated: false)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "tracer")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func configureDatabaseManager() {
        DatabaseManager.shared().persistentContainer = self.persistentContainer
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.DLog("applicationDidBecomeActive")
        pogoMM.startAccelerometerUpdates()
        SettingsBundleHelper.setVersionAndBuildNumber()
        
        checkIfAppRegistered()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Logger.DLog("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.DLog("applicationDidEnterBackground")
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

    // MARK: - Core Data Saving support

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


class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let AppVersionKey = "version_preference"
    }

    class func setVersionAndBuildNumber() {
        let version = UIApplication.appVersion
        UserDefaults.standard.set(version, forKey: "version_preference")
    }
}
