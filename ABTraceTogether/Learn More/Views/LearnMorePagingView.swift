import Foundation
import UIKit

class LearnMorePagingView: UIView {
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.borderColor = UIColor(red: 0.76, green: 0.84, blue: 0.89, alpha: 1.00).cgColor
        scrollView.layer.borderWidth = 1.0
        scrollView.layer.cornerRadius = 8
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var pageControlContainer: UIView = {
        let pageControlContainer = UIView()
        pageControlContainer.translatesAutoresizingMaskIntoConstraints = false
        pageControlContainer.layer.borderColor = UIColor(red: 0.76, green: 0.84, blue: 0.89, alpha: 1.00).cgColor
        pageControlContainer.layer.borderWidth = 1.0
        pageControlContainer.layer.cornerRadius = 8
        pageControlContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        pageControlContainer.backgroundColor = UIColor(red: 0.92, green: 0.96, blue: 0.98, alpha: 1.00)
        return pageControlContainer
    }()

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(onPageChanged), for: .valueChanged)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.74, green: 0.80, blue: 0.84, alpha: 1.00)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.00, green: 0.44, blue: 0.77, alpha: 1.00)
        return pageControl
    }()

    private var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(onNextTapped), for: .touchUpInside)
        nextButton.setButton(
            with: nextText,
            and: .secondaryArrow,
            buttonStyle: .underline
        )
        return nextButton
    }()

    init() {
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        scrollView.delegate = self

        self.addSubview(pageControlContainer)
        NSLayoutConstraint.activate([
            pageControlContainer.heightAnchor.constraint(equalToConstant: 60),
            pageControlContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pageControlContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageControlContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        var pageControlLeadingPadding = 15
        if #available(iOS 14, *) {
            pageControlLeadingPadding = -15
        }

        pageControlContainer.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: pageControlContainer.centerYAnchor),
            pageControl.leadingAnchor.constraint(equalTo: pageControlContainer.leadingAnchor, constant: CGFloat(pageControlLeadingPadding))
        ])

        pageControlContainer.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: pageControlContainer.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: pageControlContainer.trailingAnchor, constant: -15)
        ])

        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControlContainer.topAnchor)
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    func addCard(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)

        stackView.addArrangedSubview(view)

        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true

        pageControl.numberOfPages += 1
    }

    @objc
    func onNextTapped(_ sender: Any) {
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            scrollView.contentOffset.x += scrollView.frame.width
        }
    }

    @objc
    private func onPageChanged(_ sender: Any) {
        scrollView.contentOffset.x = scrollView.frame.width * CGFloat(pageControl.currentPage)
    }
}

extension LearnMorePagingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)

        if (pageControl.currentPage == pageControl.numberOfPages - 1) {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
}
