import Foundation
import UIKit

class ExplanationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generateExplanationViews(in: contentView)
    }
}

// MARK:
extension ExplanationViewController {
    override func createButton(in parentView: UIView) {
        let bottomButton = UIButton()
        parentView.addSubview(bottomButton)

        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        bottomButton.setButton(with: continueButtonString, and: .arrow)
        bottomButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

// MARK: 
extension ExplanationViewController {
    private func generateExplanationViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)
        generateContent(in: stackView)

        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }

    private func generateContent(in parentView: UIStackView) {
        let header = UILabel()
        parentView.addArrangedSubview(header)

        header.setLabel(
            with: explanationHeader,
            using: .h2LeftAligned
        )

        generateItem(imageName: "Phone", titleText: explanationSublabel1, contentText: explanationInfoLabel1, parentView: parentView)
        generateItem(imageName: "Bluetooth", titleText: explanationSublabel2, contentText: explanationInfoLabel2, parentView: parentView)
        generateItem(imageName: "Location", titleText: explanationSublabel3, contentText: explanationInfoLabel3, parentView: parentView)
        generateItem(imageName: "Bell", titleText: explanationSublabel4, contentText: explanationInfoLabel4, parentView: parentView)
    }

    func generateItem(imageName: String, titleText: String, contentText: String, parentView: UIStackView) {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addArrangedSubview(itemView)

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        itemView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.image = UIImage(named: imageName)

        let titleLabel = UILabel()
        itemView.addSubview(titleLabel)

        titleLabel.setLabel(
            with: titleText,
            using: .itemText
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true

        createInfoView(contentText: contentText, titleLabel: titleLabel, parentView: itemView)
    }

    private func createInfoView(contentText: String, titleLabel: UILabel, parentView: UIView) {
        let infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
        infoView.layer.masksToBounds = true
        infoView.layer.cornerRadius = 6

        parentView.addSubview(infoView)
        infoView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -14).isActive = true
        infoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11).isActive = true
        infoView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true

        let infoImageView = UIImageView()
        infoView.addSubview(infoImageView)
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        infoImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 13).isActive = true
        infoImageView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 13).isActive = true
        infoImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        infoImageView.image = UIImage(named: "Info")

        let label = UILabel()
        infoView.addSubview(label)
        label.setLabel(
            with: contentText,
            using: .infoText
        )

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 11).isActive = true
        label.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -14).isActive = true
        label.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10).isActive = true
    }
}
