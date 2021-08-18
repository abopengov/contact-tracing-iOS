import SafariServices
import UIKit

class PotentialExposuresViewController: UIViewController {
    @IBOutlet private var pagingView: LearnMorePagingView!
    @IBOutlet private var potentialExposuresLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        potentialExposuresLabel.setLabel(with: potentialExposuresTitle, using: .blackTitleText)

        let page1: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page1.image = UIImage(named: "PotentialExposuresCard1")
        page1.text = potentialExposuresPage1Details

        let page2: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page2.image = UIImage(named: "PotentialExposuresCard2")
        page2.text = potentialExposuresPage2Details

        let page3: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page3.image = UIImage(named: "PotentialExposuresCard3")
        page3.text = potentialExposuresPage3Details

        let page4: LearnMoreFourItemCardView = Bundle.main.loadNibNamed("LearnMoreFourItemCardView", owner: self, options: nil)?.first as! LearnMoreFourItemCardView
        page4.titleText = potentialExposuresPage4Title
        page4.item1Text = potentialExposuresPage4Details1
        page4.item2Text = potentialExposuresPage4Details2
        page4.item3Text = potentialExposuresPage4Details3
        page4.item4Text = potentialExposuresPage4Details4
        page4.item1Image = UIImage(named: "Home")
        page4.item2Image = UIImage(named: "Positive")
        page4.item3Image = UIImage(named: "PillBottle")
        page4.item4Image = UIImage(named: "Help")

        page4.addLinkToItem(itemIndex: 4, textToFind: potentialExposuresPage4Details4LinkText, linkURL: closeContactsFaqLink)
        page4.delegate = self

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

extension PotentialExposuresViewController: LearnMoreFourItemCardViewDelegate {
    func linkClickedWithValue(_ value: Any) {
        if let urlString = value as? String, let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
}
