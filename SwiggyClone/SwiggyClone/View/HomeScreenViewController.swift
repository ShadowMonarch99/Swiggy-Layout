//
//  HomeScreenViewController.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    private var stickySearchView = HomePageStickyHeaderView()
    private var orangeBackdropView = UIView()
    private var viewModel = HomeScreenViewModel()
    private var refreshControl = UIRefreshControl()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupPullToRefresh()
        setupDataSource()
        applySnapshot()
    }
    
    override func viewDidLayoutSubviews() {
        stickySearchView.addLightShadowBottomSides()
        super.viewDidLayoutSubviews()
    }
    
    func setupView() {
        view.addSubview(orangeBackdropView)
        orangeBackdropView.anchor(view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,heightConstant: 55)
        orangeBackdropView.backgroundColor = .orange

        
        view.addSubview(stickySearchView)
        
        stickySearchView.anchor(view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topConstant: 50)
        
        stickySearchView.configure(addressTag: viewModel.getAddressTag(), completeAddress: viewModel.getAddressLine())
    }
    
    func navigateToVendorDetailViewController(vendor: Vendor, frame: CGRect) {
        let viewModel = HomeScreenViewModel()
        viewModel.currentSelectedVendor = vendor
        
        let detailVC = VendorDetailViewController(viewModel: viewModel)
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
}

private extension HomeScreenViewController {
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch Section.allCases[sectionIndex] {
            case .banners:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(190)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .vendorWidgets:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(280)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ScrollingBannerCell.self, forCellWithReuseIdentifier: String(describing: ScrollingBannerCell.self))
        collectionView.register(VendorGridCell.self, forCellWithReuseIdentifier: String(describing: VendorGridCell.self))
        
        view.addSubview(collectionView)
        collectionView.anchor(stickySearchView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: -10)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        view.bringSubviewToFront(stickySearchView)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            let section = Section.allCases[indexPath.section]
            
            switch section {
            case .banners:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScrollingBannerCell.self), for: indexPath) as! ScrollingBannerCell
                cell.configure(with: item.banners)
                return cell
                
            case .vendorWidgets:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VendorGridCell.self), for: indexPath) as! VendorGridCell
                cell.configure(vendors: item.foodVendors)
                cell.selectionPublisher
                    .sink { [weak self] (vendor, frame) in
                        self?.navigateToVendorDetailViewController(vendor: vendor
                                                                  , frame: frame)
                    } .store(in: &cell.cancellables)
                return cell
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.banners, .vendorWidgets])
        
        let item = viewModel.getMockData()
        let bannersItem = Item(banners: item.banners, foodVendors: [])
        snapshot.appendItems([bannersItem], toSection: .banners)
        
        let vendorsItem = Item(banners: [], foodVendors: item.foodVendors)
        snapshot.appendItems([vendorsItem], toSection: .vendorWidgets)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// Pull to refresh
private extension HomeScreenViewController {
    func setupPullToRefresh() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.collectionView.alpha = 0.9
        self.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.applySnapshot()
            self.collectionView.alpha = 1.0
            self.collectionView.isUserInteractionEnabled = true
            self.refreshControl.endRefreshing()
        }
    }
}
