//
//  HomeScreenViewModel.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 07/12/24.
//

import Foundation
import UIKit

enum Section: CaseIterable {
    case banners
    case vendorWidgets
}

class HomeScreenViewModel {
    
    private var items: [Item] = []
    var currentSelectedVendor: Vendor?

    func getAddressTag() -> String {
        return "Office"
    }
    
    func getAddressLine() -> String {
        return "A-23, Laghu Udyog Kendra, I B Patel Road, Goregaon( East)"
    }
    
    func getItems() -> [Item] {
        items
    }

    func getMockData() -> Item {
        let banner1 = Banner(text: "Delicious Food!", image: "Banner1")
        let banner2 = Banner(text: "Nothing unites people quite like food", image: "Banner2")
        let banner3 = Banner(text: "Limited Time Offer", image: "Banner3")
        
        let banners = [banner1, banner2, banner3] + Array(repeating: banner1, count: 3)
        
        let vendor1 = Vendor(text: "Tasty Bites", image: "VendorImageSample")
        let vendor2 = Vendor(text: "Spicy Grill", image: "VendorImageSample")
        let vendor3 = Vendor(text: "Healthy Eats", image: "VendorImageSample")
        
        let vendors = [vendor1, vendor2, vendor3] + Array(repeating: vendor3, count: 7)
        
        return Item(banners: banners, foodVendors: vendors)
    }

}

