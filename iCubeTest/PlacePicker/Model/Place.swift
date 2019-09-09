//
//  Place.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation

struct PlaceData: Codable {
    var places: [Place]?
}

struct Place: Codable {
    var id: Int?
    var name: String?
    var price: Int?
    var latitude: String?
    var longitude: String?
    var isSelected: Bool?
}
