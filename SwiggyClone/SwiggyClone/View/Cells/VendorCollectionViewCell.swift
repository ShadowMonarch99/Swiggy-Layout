//
//  VendorCollectionViewCell.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit
import Combine

class VendorCollectionViewCell: UICollectionViewCell {
    
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
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var selectionPublisher = PassthroughSubject<(Vendor, CGRect), Never>()
    var cancellables = Set<AnyCancellable>()
    private var vendor: Vendor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cancellables.removeAll()
        super.prepareForReuse()
    }
    
    
    private func setupCell() {
        contentView.addSubview(mainContainerStackView)
        mainContainerStackView.fillSuperview(edgetInset: .init(top: 5, left: 5, bottom: 5, right: 5))
        
        mainContainerStackView.addArrangedSubview(vendorImageView)
        vendorImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        vendorImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        mainContainerStackView.addArrangedSubview(vendorLabel)
        vendorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    func configure(with vendor: Vendor) {
        self.vendor = vendor
        vendorLabel.text = vendor.text
        if let imageUrl = vendor.image {
            vendorImageView.image = UIImage(named: imageUrl)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        contentView.alpha = 0.5
        if let vendor = vendor {
            selectionPublisher.send((vendor, self.contentView.frame))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.contentView.alpha = 1
        }
    }
    
}

