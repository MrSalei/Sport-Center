//
//  PayWallViewController.swift
//  Sport Center
//
//  Created by luqrri on 1.08.22.
//

import UIKit
import Adapty

final class PayWallViewController: UIViewController, PayWallViewDelegate {
    
    private let primaryView = PayWallView()
    
    private let viewModel: PayWallView.ViewModel
    
    init(viewModel: PayWallView.ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        primaryView.configure(with: viewModel)
        primaryView.delegate = self
        layout()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func payWallViewDidTapPurchase(_ paywall: PayWallView, product: ProductModel) {
        Adapty.makePurchase(product: product) { [weak self] purchaserInfo, receipt, appleValidationResult, product, error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Purchased", message: "Welcome to VIP", preferredStyle: .alert)
                alert.addAction(.init(title: "Dismiss", style: .cancel) { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true)
                    }
                })
                self?.present(alert, animated: true)
            }
        }
    }
    
}
