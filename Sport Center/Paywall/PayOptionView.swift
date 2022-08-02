//
//  PayOptionView.swift
//  Sport Center
//
//  Created by luqrri on 1.08.22.
//

import UIKit
import Adapty

protocol PayOptionViewDelegate: AnyObject {
    func payOptionView(_ optionView: PayOptionView, didTapSelect product: ProductModel)
}

final class PayOptionView: UIView {
    
    weak var delegate: PayOptionViewDelegate?
    
    public var isSelected: Bool = false {
        didSet {
            layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.lightGray.cgColor
        }
    }
    
    private var product: ProductModel? {
        didSet {
            titleLabel.text = product?.localizedTitle
            subtitleLabel.text = product?.localizedDescription
            priceLabel.text = product?.localizedPrice
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUpTap()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        backgroundColor = .clear
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    @objc private func didTap() {
        guard let product = product else { return }
        delegate?.payOptionView(self, didTapSelect: product)
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(priceLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with product: ProductModel, theme: PayWallView.ViewModel.Theme) {
        self.product = product
        switch theme {
            case .light:
                titleLabel.textColor = .black
                subtitleLabel.textColor = .black
                priceLabel.textColor = .black
            case .dark:
                titleLabel.textColor = .white
                subtitleLabel.textColor = .white
                priceLabel.textColor = .white
        }
    }
    
}
