//
//  PlacePickerInterface.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation

protocol PlacePickerInterface {
    func getPlaces()
}

protocol PlacePickerDelegate: class {
    func didSuccessGetPlace(response: PlaceData)
    func didFailedGetPlace(response: GoodBoyError)
}
