import UIKit

class HowWillIBeNotifiedController: UIViewController {
    @IBOutlet private var pagingView: LearnMorePagingView!
    @IBOutlet private var howWillIBeNotifiedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        howWillIBeNotifiedLabel.setLabel(with: howWillIBeNotifiedTitle, using: .blackTitleText)

        let page1: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page1.image = UIImage(named: "HowWillIBeNotifiedCard1")
        page1.text = howWillIBeNotifiedPage1Details

        let page2: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page2.image = UIImage(named: "HowWillIBeNotifiedCard2")
        page2.text = howWillIBeNotifiedPage2Details

        let page3: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page3.image = UIImage(named: "HowWillIBeNotifiedCard3")
        page3.text = howWillIBeNotifiedPage3Details

        let page4: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page4.image = UIImage(named: "HowWillIBeNotifiedCard4")
        page4.text = howWillIBeNotifiedPage4Details

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
