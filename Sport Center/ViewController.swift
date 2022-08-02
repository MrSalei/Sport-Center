//
//  ViewController.swift
//  Sport Center
//
//  Created by luqrri on 1.08.22.
//

import Adapty
import UIKit

class ViewController: UIViewController {

    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Purchase", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private var paywalls = [PaywallModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        getPayWalls()
    }
    
    private func setUpButton() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.isHidden = false
        Adapty.getPurchaserInfo(forceUpdate: true) { [weak self] info, error in
            guard let info = info, error == nil else { return }
            let isSubscribed = info.accessLevels["premium"]?.isActive == true
            if !isSubscribed {
                DispatchQueue.main.async {
                    self?.button.isHidden = false
                }
            }
        }
    }
    
    @objc private func didTapButton() {
        // guard let model = paywalls.last
        guard let model = paywalls.last, let config = model.customPayload,
                let title = config["title"] as? String, let subtitle = config["subtitle"] as? String,
                let axis = config["axis"] as? String, let theme = config["theme"] as? String
                else { return }
                
        let viewModel = PayWallView.ViewModel(title: title, subtitle: subtitle, axis: PayWallView.ViewModel.Axis(rawValue: axis) ?? .vertical, theme: PayWallView.ViewModel.Theme(rawValue: theme) ?? .dark, products: model.products)
        
        Adapty.logShowPaywall(model)
        
        let vc = PayWallViewController(viewModel: viewModel)
        present(vc, animated: true)
    }

    private func getPayWalls() {
        Adapty.getPaywalls { [weak self] paywalls, _, error in
            guard let paywalls = paywalls, error == nil else { return }
            self?.paywalls = paywalls
        }
    }
    
}
