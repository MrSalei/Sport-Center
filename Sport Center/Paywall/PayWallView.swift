//
//  PayWallView.swift
//  Sport Center
//
//  Created by luqrri on 1.08.22.
//

import UIKit
import Adapty

protocol PayWallViewDelegate: AnyObject {
    func payWallViewDidTapPurchase(_ paywall: PayWallView, product: ProductModel)
}

final class PayWallView: UIView {
    
    weak var delegate: PayWallViewDelegate?
    
    private var selectedProduct: ProductModel?
    
    struct ViewModel {
        let title: String
        let subtitle: String
        let axis: Axis
        let theme: Theme
        let products: [ProductModel]
        
        enum Theme: String {
            case light, dark
        }
        
        enum Axis: String {
            case horizontal, vertical
        }
        
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setAttributedTitle(
            .init(string: "Subscribe", attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 22, weight: .medium)
            ]),
            for: .normal
        )
        button.alpha = 0.5
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemPink
        imageView.image = UIImage(systemName: "crown")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setUpButton()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        let guide = UILayoutGuide()
        addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            guide.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            guide.leadingAnchor.constraint(equalTo: leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: trailingAnchor),
            guide.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor),
            
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            subscribeButton.widthAnchor.constraint(equalToConstant: 200),
            subscribeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            subscribeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(subscribeButton)
        addSubview(stackView)
        addSubview(imageView)
    }
    
    private func setUpButton() {
        subscribeButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        guard let product = selectedProduct else { return }
        delegate?.payWallViewDidTapPurchase(self, product: product)
    }
    
    private func setUpProducts(products: [ProductModel], theme: ViewModel.Theme) {
        for product in products {
            let optionView = PayOptionView()
            optionView.configure(with: product, theme: theme)
            optionView.delegate = self
            optionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackView.addArrangedSubview(optionView)
        }
    }
    
    public func configure(with viewModel: ViewModel) {
        
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        stackView.axis = viewModel.axis == .vertical ? .vertical : .horizontal
        stackView.distribution = viewModel.axis == .vertical ? .equalCentering : .fillEqually
        setUpProducts(products: viewModel.products, theme: viewModel.theme)
        
        switch viewModel.theme {
            case .light:
                titleLabel.textColor = .black
                subtitleLabel.textColor = .lightGray
                backgroundColor = .white
            case .dark:
                titleLabel.textColor = .systemBlue
                subtitleLabel.textColor = .white
                backgroundColor = UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33 / 255.0, alpha: 1)
        }
    }
}

extension PayWallView: PayOptionViewDelegate {

    func payOptionView(_ optionView: PayOptionView, didTapSelect product: ProductModel) {
        resetSelection()
        selectedProduct = product
        optionView.isSelected = true
        subscribeButton.alpha = 1
    }
    
    private func resetSelection() {
        selectedProduct = nil
        for view in stackView.arrangedSubviews {
            (view as? PayOptionView)?.isSelected = false
        }
    }
}
