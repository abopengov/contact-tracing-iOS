import Foundation
import SafariServices
import UIKit

class MoreViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var moreTableView: UITableView!
    @IBOutlet private var errorLabel: UILabel!

    private var moreLinks: [MoreLink] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.setLabel(with: moreTitle, using: .blackTitleText)

        moreTableView.separatorStyle = .none
        moreTableView.delegate = self
        moreTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let urlsRepository = UrlsRepository()
        urlsRepository.getMoreLinks { moreLinks in
            if let moreLinks = moreLinks {
                self.errorLabel.isHidden = true
                self.moreTableView.isHidden = false
                self.moreLinks = moreLinks
                self.moreTableView.reloadData()
            } else {
                self.moreTableView.isHidden = true
                self.errorLabel.isHidden = false
                self.errorLabel.setLabel(with: errorCannotFetchData, using: .errorMediumText)
            }
        }
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moreLinks.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moreLinkCell = tableView.dequeueReusableCell(withIdentifier: "MoreLinkCell", for: indexPath) as! MoreLinkCell
        let moreLink = moreLinks[indexPath.row]

        if let title = moreLink.title {
            moreLinkCell.titleLabel.setLabel(with: title, using: .blueText, localize: false)
        } else {
            moreLinkCell.titleLabel.setLabel(with: "", using: .blueText, localize: false)
        }
        moreLinkCell.selectionStyle = .none

        return moreLinkCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moreLink = moreLinks[indexPath.row]
        if let link = moreLink.link,
           let url = URL(string: link) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
}
