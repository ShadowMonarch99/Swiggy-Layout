//
//  HomePageStickyHeaderView.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import UIKit

class HomePageStickyHeaderView : UIView {
    
    private var mainContainerView = UIView()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private var addressAndProfileHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        return stackView
    }()
    
    private var addressTagHorizontalStackView = UIStackView()
    
    private var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "LocationMarker") //unable to find the exact icon in the given time, using a generic location marker
        return imageView
    }()
    
    
    private var addressTagLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var downArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "DownArrow")
        return imageView
    }()
    
    private var spacerView = UIView()
    
    private var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ProfileIcon")
        return imageView
    }()
    
    private var addressVerticalStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private var addressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    //Ideally this should be a search component, but for the demo purpose i shall just use a text field
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search for biryani"
        textField.tintColor = .gray
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainContainerView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 5.0)
    }
        
    func configure(addressTag: String?, completeAddress: String?) {
        addressTagLabel.text = addressTag
        addressLabel.text = completeAddress
    }
}

private extension HomePageStickyHeaderView {
    func setupView() {
        addSubview(mainContainerView)
        mainContainerView.fillSuperview(edgetInset: .init(top: 0, left: 0, bottom: 5, right: 0))
        mainContainerView.backgroundColor = .orange
        
        mainContainerView.addSubview(mainStackView)
        mainStackView.fillSuperview(edgetInset: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        setupAddressTagView()
        addressVerticalStackView.addArrangedSubview(addressTagHorizontalStackView)
        addressVerticalStackView.addArrangedSubview(addressLabel)
        
        addressAndProfileHorizontalStackView.addArrangedSubview(addressVerticalStackView)
        addressAndProfileHorizontalStackView.addArrangedSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mainStackView.addArrangedSubview(addressAndProfileHorizontalStackView)
        mainStackView.addArrangedSubview(searchTextField)
    }
    
    func setupAddressTagView() {
        addressTagHorizontalStackView.addArrangedSubview(arrowImageView)
        arrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        addressTagHorizontalStackView.addArrangedSubview(addressTagLabel)
        
        addressTagHorizontalStackView.addArrangedSubview(downArrowImageView)
        downArrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        downArrowImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        addressTagHorizontalStackView.addArrangedSubview(spacerView)
    }
    
    func setupGestureRecognizers() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImage.addGestureRecognizer(profileTapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let addressTagTapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTagSelected))
        addressTagHorizontalStackView.addGestureRecognizer(addressTagTapGesture)
        addressTagHorizontalStackView.isUserInteractionEnabled = true
    }
        
    @objc func addressTagSelected() {
        //can assign specific utilities to it later
        print("Address Tag Tapped")
    }
    
    @objc func profileTapped() {
        //can assign specific utilities to it later
        print("Profile Icon Tapped")
    }
}
