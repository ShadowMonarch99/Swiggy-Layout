//
//  ScrollingBannerCell.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class ScrollingBannerCell: UICollectionViewCell {
    
    private let titleView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "Offers for you"
        return label
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .darkGray
        separator.alpha = 0.2
        return separator
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let bannerCollectionView: UICollectionView
    
    private var banners: [Banner] = []
    private var collectionViewLeadingConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannerCollectionView.showsVerticalScrollIndicator = false
        bannerCollectionView.showsHorizontalScrollIndicator = false
        
        super.init(frame: frame)
        setupSubviews()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        //TitleView and Separator
        contentView.addSubview(titleView)
        titleView.anchor(contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, leadingConstant: 15, trailingConstant: 15, heightConstant: 20)
        
        titleView.addSubview(separator)
        separator.anchor(leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, heightConstant: 1.5)
        separator.anchorCenterYToSuperview()
        
        titleView.addSubview(titleLabel)
        titleLabel.anchorCenterSuperview()
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Banner Collection View
        contentView.addSubview(bannerCollectionView)
        bannerCollectionView.anchor(titleView.bottomAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, topConstant: 8, bottomConstant: 8)
        collectionViewLeadingConstraint = bannerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        collectionViewLeadingConstraint?.isActive = true
        
        // Page Control
        contentView.addSubview(pageControl)
        pageControl.anchor(leading: contentView.leadingAnchor, bottom: bannerCollectionView.bottomAnchor, trailing: contentView.trailingAnchor, bottomConstant: 8, heightConstant: 5)
    }
    
    private func setupCollectionView() {
        bannerCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        }
    }
    
    func configure(with banners: [Banner]) {
        self.banners = banners
        pageControl.numberOfPages = banners.count
        bannerCollectionView.reloadData()
    }
}

extension ScrollingBannerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else {
            fatalError("Could not dequeue BannerCollectionViewCell")
        }
        cell.configure(with: banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You tapped on: \(banners[indexPath.item].text ?? "")")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        
        adjustLeadingConstraint(for: page)
    }
    
    private func adjustLeadingConstraint(for page: Int) {
        collectionViewLeadingConstraint?.isActive = false
        collectionViewLeadingConstraint?.constant = page > 0 ? 0 : 10
        collectionViewLeadingConstraint?.isActive = true
    }
}

extension ScrollingBannerCell: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let itemWidth = layout.itemSize.width + layout.minimumLineSpacing
        let targetOffset = targetContentOffset.pointee.x
        var index = round(targetOffset / itemWidth)
        
        index = max(0, min(index, CGFloat(banners.count - 1)))
        targetContentOffset.pointee = CGPoint(x: index * itemWidth, y: targetContentOffset.pointee.y)
    }
}
