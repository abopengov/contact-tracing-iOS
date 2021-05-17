import UIKit

class PermissionsController: UIViewController {
    @IBOutlet private var permissionsLabel: UILabel!
    @IBOutlet private var pagingView: LearnMorePagingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        permissionsLabel.setLabel(with: permissionsTitle, using: .blackTitleText)

        let page1: LearnMoreRequestCardView = Bundle.main.loadNibNamed("LearnMoreRequestCardView", owner: self, options: nil)?.first as! LearnMoreRequestCardView
        page1.topIcon = UIImage(named: "Location")
        page1.willTitleText = permissionsPage1WillTitle
        page1.willItem1Text = permissionsPage1WillItem1
        page1.willNotTitleText = permissionsPage1WillNotTitle
        page1.willNotItem1Text = permissionsPage1WillNotItem1

        let page2: LearnMoreRequestCardView = Bundle.main.loadNibNamed("LearnMoreRequestCardView", owner: self, options: nil)?.first as! LearnMoreRequestCardView
        page2.topIcon = UIImage(named: "Bluetooth")
        page2.willTitleText = permissionsPage2WillTitle
        page2.willItem1Text = permissionsPage2WillItem1
        page2.willItem2Text = permissionsPage2WillItem2
        page2.willNotTitleText = permissionsPage2WillNotTitle
        page2.willNotItem1Text = permissionsPage2WillNotItem1

        let page3: LearnMoreRequestCardView = Bundle.main.loadNibNamed("LearnMoreRequestCardView", owner: self, options: nil)?.first as! LearnMoreRequestCardView
        page3.topIcon = UIImage(named: "Phone")
        page3.willTitleText = permissionsPage3WillTitle
        page3.willItem1Text = permissionsPage3WillItem1
        page3.willNotTitleText = permissionsPage3WillNotTitle
        page3.willNotItem1Text = permissionsPage3WillNotItem1

        let page4: LearnMoreRequestCardView = Bundle.main.loadNibNamed("LearnMoreRequestCardView", owner: self, options: nil)?.first as! LearnMoreRequestCardView
        page4.topIcon = UIImage(named: "Bell")
        page4.willTitleText = permissionsPage4WillTitle
        page4.willItem1Text = permissionsPage4WillItem1
        page4.willNotTitleText = permissionsPage4WillNotTitle
        page4.willNotItem1Text = permissionsPage4WillNotItem1

        let pages = [page1, page2, page3, page4]

        for i in 0 ..< pages.count {
            pagingView.addCard(view: pages[i])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
