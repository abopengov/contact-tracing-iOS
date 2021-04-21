import UIKit

class TestingPositiveViewController: UIViewController {
    @IBOutlet private var pagingView: LearnMorePagingView!
    @IBOutlet private var testingPositiveLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        testingPositiveLabel.setLabel(with: testingPositiveTitle, using: .blackTitleText)

        let page1: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page1.image = UIImage(named: "TestingPositiveCard1")
        page1.text = testingPositivePage1Details

        let page2: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page2.image = UIImage(named: "TestingPositiveCard2")
        page2.text = testingPositivePage2Details

        let page3: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page3.image = UIImage(named: "TestingPositiveCard3")
        page3.text = testingPositivePage3Details

        let page4: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page4.image = UIImage(named: "TestingPositiveCard4")
        page4.text = testingPositivePage4Details

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
