import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func presentViewController(_ viewController: UIViewController)
    func switchTab(_ tabName: TabName)
    func switchTab(_ tabName: TabName, segueName: String)
    func presentDebugMode()
    func openUploadFlow()
    func openPauseDetection()
    func refreshHomeScreen()
}
