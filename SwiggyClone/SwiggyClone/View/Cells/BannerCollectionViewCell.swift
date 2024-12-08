//
//  BannerCollectionViewCell.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupCell() {
        contentView.addSubview(bannerImageView)
        bannerImageView.fillSuperview()
        
    }
    
    func configure(with banner: Banner) {
        if let imageUrl = banner.image {
            bannerImageView.image = UIImage(named: imageUrl)
        }
    }
}
