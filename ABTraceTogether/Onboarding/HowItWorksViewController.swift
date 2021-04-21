import UIKit

class HowItWorksViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generateHowItWorksViews(in: contentView)
    }
}

// MARK: 
extension HowItWorksViewController {
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
extension HowItWorksViewController {
    private func generateHowItWorksViews(in contentView: UIView) {
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
        let willLabel = UILabel()
        parentView.addArrangedSubview(willLabel)

        willLabel.setLabel(
            with: howItWorksWillTitle,
            using: .h2LeftAligned
        )

        generateBulletItem(imageName: "BlueCheck", text: howItWorksWillSublabel1, parentView: parentView)
        generateBulletItem(imageName: "BlueCheck", text: howItWorksWillSublabel2, parentView: parentView)
        generateBulletItem(imageName: "BlueCheck", text: howItWorksWillSublabel3, parentView: parentView)
        generateBulletItem(imageName: "BlueCheck", text: howItWorksWillSublabel4, parentView: parentView)

        let divider = UIView()
        parentView.addArrangedSubview(divider)
        divider.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let willNotLabel = UILabel()
        parentView.addArrangedSubview(willNotLabel)

        willNotLabel.setLabel(
            with: howItWorksThisAppWillNotTitle,
            using: .h2LeftAligned
        )

        generateBulletItem(imageName: "RedXMedium", text: howItWorksWillNotSublabel1, parentView: parentView)
        generateBulletItem(imageName: "RedXMedium", text: howItWorksWillNotSublabel2, parentView: parentView)
    }

    func generateBulletItem(imageName: String, text: String, parentView: UIStackView) {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false

        parentView.addArrangedSubview(newView)
        let imageView = UIImageView()
        newView.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: newView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: newView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.image = UIImage(named: imageName)

        let label = UILabel()
        newView.addSubview(label)
        label.setLabel(
            with: text,
            using: .itemText
        )

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: newView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: newView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: newView.bottomAnchor).isActive = true
    }
}
