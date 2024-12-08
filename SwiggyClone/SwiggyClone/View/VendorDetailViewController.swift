//
//  VendorDetailViewController.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class VendorDetailViewController: UIViewController {
    
    private let crossImageContainerView = UIView()
    
    private let crossImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Cross")
        return imageView
    }()

    private var mainContainerStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let vendorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let vendorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var cellFrame: CGRect!
    var viewModel: HomeScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    init(viewModel: HomeScreenViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        if let imageUrl = viewModel.currentSelectedVendor?.image {
            vendorImageView.image = UIImage(named: imageUrl)
        }
        vendorLabel.text = viewModel.currentSelectedVendor?.text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        view.addSubview(mainContainerStackView)
        mainContainerStackView.anchor(view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        mainContainerStackView.addArrangedSubview(vendorImageView)
        vendorImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        vendorImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        mainContainerStackView.addArrangedSubview(vendorLabel)
        
        view.addSubview(crossImageContainerView)
        crossImageContainerView.anchor(view.topAnchor, trailing: view.trailingAnchor, topConstant: 50, trailingConstant: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(crossButtonAction))
        crossImageContainerView.addGestureRecognizer(tapGesture)
        
        crossImageContainerView.addSubview(crossImageView)
        crossImageView.fillSuperview(edgetInset: .init(top: 5, left: 5, bottom: 5, right: 5))
        crossImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        crossImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc private func crossButtonAction() {
        dismissView()
    }
    
    func dismissView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true)
        }
    }

}
