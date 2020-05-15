import UIKit
import CoreData
import CoreMotion
import IBMMobileFirstPlatformFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var pogoMM: PogoMotionManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Enable this to pin own certificate
//        WLClient.sharedInstance().pinTrustedCertificatePublicKey(fromFile: "certificate.cer")
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
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Logger.DLog("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.DLog("applicationDidEnterBackground")

        let magicNumber = Int.random(in: 0 ... PushNotificationConstants.dailyRemPushNotifContents.count - 1)
        pogoMM.stopAllMotion()

        BlueTraceLocalNotifications.shared.removePendingNotificationRequests()

        BlueTraceLocalNotifications.shared.triggerCalendarLocalPushNotifications(pnContent: PushNotificationConstants.dailyRemPushNotifContents[magicNumber], identifier: "appBackgroundNotifId")
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
