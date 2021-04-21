import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func presentViewController(_ viewController: UIViewController)
    func switchTab(_ tabName: TabName)
    func presentDebugMode()
    func connectToUploadFlow()
}
