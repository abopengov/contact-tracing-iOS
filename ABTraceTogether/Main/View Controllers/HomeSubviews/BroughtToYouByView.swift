import UIKit

class BroughtToYouByView: UIView {
    @IBOutlet private var albertaLogoImageView: UIImageView!
    @IBOutlet private var abertaLogoViewDetailLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        abertaLogoViewDetailLabel.setLabel(
            with: generalLogoMessageString,
            using: .eyebrowText
        )
    }
}
