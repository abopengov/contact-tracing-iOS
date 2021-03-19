import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func presentViewController(_ viewController: UIViewController)
    func switchTab(_ tabName: TabName)
    func hideCaseSummaryView(_ hide: Bool)
    func presentDebugMode(_ identifier: String)
    func connectToUploadFlow()
}
