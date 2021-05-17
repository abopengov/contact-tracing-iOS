import UIKit

class AppBasicsViewController: UIViewController {
    @IBOutlet private var pagingView: LearnMorePagingView!
    @IBOutlet private var appBasicsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        appBasicsLabel.setLabel(with: appBasicsTitle, using: .blackTitleText)

        let page1: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page1.image = UIImage(named: "AppBasicsCard1")
        page1.text = appBasicsPage1Details

        let page2: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page2.image = UIImage(named: "AppBasicsCard2")
        page2.text = appBasicsPage2Details

        let page3: LearnMoreTwoItemCardView = Bundle.main.loadNibNamed("LearnMoreTwoItemCardView", owner: self, options: nil)?.first as! LearnMoreTwoItemCardView
        page3.image = UIImage(named: "AppBasicsCard3")
        page3.item1Image = UIImage(named: "Anonymous")
        page3.item2Image = UIImage(named: "BlueUpload")
        page3.item1Text = appBasicsPage3Details1
        page3.item2Text = appBasicsPage3Details2

        let pages = [page1, page2, page3]

        for i in 0 ..< pages.count {
            pagingView.addCard(view: pages[i])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
