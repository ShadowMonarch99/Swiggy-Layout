//
//  HomeModel.swift
//  SwiggyClone
//
//  Created by Apoorv Joshi on 08/12/24.
//

import Foundation

struct Item: Hashable {
    let banners: [Banner]
    let foodVendors: [Vendor]
}

struct Banner: Hashable {
    let text: String?
    let image: String?
}

struct Vendor: Hashable {
    let text: String?
    let image: String?
}
