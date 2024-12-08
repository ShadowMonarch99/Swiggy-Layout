//
//  VendorGridCell.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit
import Combine

class VendorGridCell: UICollectionViewCell {
    private var titleView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "Tried these yet?"
        return label
    }()
    
    private var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .darkGray
        return separator
    }()
    
    
    private let vendorCollectionView: UICollectionView
    private var vendors: [Vendor] = []
    private var layout: UICollectionViewFlowLayout
    var selectionPublisher = PassthroughSubject<(Vendor, CGRect), Never>()
    var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        vendorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vendorCollectionView.showsVerticalScrollIndicator = false
        vendorCollectionView.showsHorizontalScrollIndicator = false
        
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cancellables.removeAll()
        super.prepareForReuse()
    }
    
    func configure(vendors: [Vendor]) {
        self.vendors = vendors
        vendorCollectionView.reloadData()
    }
    
    private func setupCell() {
        contentView.addSubview(titleView)
        titleView.anchor(contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, leadingConstant: 15, trailingConstant: 15, heightConstant: 20)
        
        titleView.addSubview(separator)
        separator.anchor(leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, heightConstant: 1.5)
        separator.anchorCenterYToSuperview()
        separator.alpha = 0.2
        
        titleView.addSubview(titleLabel)
        titleLabel.anchorCenterSuperview()
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(vendorCollectionView)
        vendorCollectionView.anchor(titleView.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, topConstant: 8, leadingConstant: 10, bottomConstant: 8, trailingConstant: 10)
        
        vendorCollectionView.register(VendorCollectionViewCell.self, forCellWithReuseIdentifier: "VendorCell")
        vendorCollectionView.dataSource = self
        vendorCollectionView.delegate = self
        vendorCollectionView.isUserInteractionEnabled = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = vendorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth: CGFloat = 105
            let itemHeight: CGFloat = 105
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
}

extension VendorGridCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vendor = vendors[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorCell", for: indexPath) as! VendorCollectionViewCell
        cell.configure(with: vendor)
        cell.selectionPublisher
            .sink { [weak self] (vendor, frame) in
                self?.selectionPublisher.send((vendor,frame))
            }.store(in: &cell.cancellables)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedVendor = vendors[indexPath.item]
        print("You have selected vendor: \(selectedVendor.text ?? "")")
    }
    
}
