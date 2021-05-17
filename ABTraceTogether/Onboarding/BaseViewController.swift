import UIKit

class BaseViewController: UIViewController {
    let contentView = UIView()
    let bottomView = UIView()

    let navigator: OnboardingNavigator
    let identifier: OnboardingNavigator.Destination

    init(navigator: OnboardingNavigator, identifier: OnboardingNavigator.Destination) {
        self.navigator = navigator
        self.identifier = identifier
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        generateMainView()
        createButton(in: bottomView)
    }
}

// MARK: 
extension BaseViewController {
    func clearSubViews(from parentView: UIView) {
        for subview in parentView.subviews {
            subview.removeFromSuperview()
        }
    }

    private func generateMainView() {
        let mainView = UIView()
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        mainView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true

        mainView.addSubview(bottomView)

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 84).isActive = true

        bottomView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}

extension BaseViewController {
    @objc
    func createButton(in parentView: UIView) {
        let bottomButton = UIButton()
        parentView.addSubview(bottomButton)

        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        bottomButton.setButton(with: nextButtonText, and: .arrow)
        bottomButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

// MARK: 
extension BaseViewController {
    @objc
    func buttonAction(_ sender: UIButton) {
        navigator.navigate(from: identifier)
    }
}
