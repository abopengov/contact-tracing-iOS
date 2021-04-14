import UIKit

class MessageView: UIView {
    @IBOutlet private var messageView: UIView!
    @IBOutlet private var messageImageView: UIImageView!
    @IBOutlet private var messageHeaderLabel: UILabel!
    @IBOutlet private var messageDetailLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        HomeScreenEnum.setUpHomeBackgroundDesign(view: messageView)
        messageHeaderLabel.setLabel(
            with: homeMessageHeader,
            using: .h2
        )
        messageHeaderLabel.textAlignment = .left
        messageDetailLabel.setLabel(
            with: homeMessageDetailedMessage,
            using: .body
        )
        messageDetailLabel.textAlignment = .left
    }
}
