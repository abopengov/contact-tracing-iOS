import UIKit

class InfoExchangedController: UIViewController {
    @IBOutlet private var infoExchangedLabel: UILabel!
    @IBOutlet private var pagingView: LearnMorePagingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        infoExchangedLabel.setLabel(with: infoExchangedTitle, using: .blackTitleText)

        let page1: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page1.image = UIImage(named: "BluetoothSignals")
        page1.text = infoExchangedPage1Details

        let page2: LearnMoreRequestCardView = Bundle.main.loadNibNamed("LearnMoreRequestCardView", owner: self, options: nil)?.first as! LearnMoreRequestCardView
        page2.willTitleText = infoExchangedPage2Title1
        page2.willItem1Image = UIImage(named: "Phone")
        page2.willItem1Text = infoExchangedPage2Details1
        page2.willNotTitleText = infoExchangedPage2Title2
        page2.willNotItem1Image = UIImage(named: "Anonymous")
        page2.willNotItem1Text = infoExchangedPage2Details2
        page2.willNotItem2Image = UIImage(named: "BlueCircleX")
        page2.willNotItem2Text = infoExchangedPage2Details3

        let page3: LearnMorePayloadExampleCardView = Bundle.main.loadNibNamed("LearnMorePayloadExampleCardView", owner: self, options: nil)?.first as! LearnMorePayloadExampleCardView

        let page4: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        page4.image = UIImage(named: "Lock")
        page4.text = infoExchangedPage4Details

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
