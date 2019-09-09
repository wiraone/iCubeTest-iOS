//
//  PlacePickerPresenter.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class PlacePickerPresenter: PlacePickerInterface {
    private weak var delegate: PlacePickerDelegate?
    
    init(delegate: PlacePickerDelegate) {
        self.delegate = delegate
    }
    
    func getPlaces() {
        let target = GoodBoyAPI.getPlaces
        let future = NetworkFuture<Data>()
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: .black, backgroundColor: .clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        future.request(target: target)
            .done { [weak self] dic in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                let decoder = JSONDecoder()
                let result = try decoder.decode(PlaceData.self, from: dic)
                self?.delegate?.didSuccessGetPlace(response: result)
            }.catch { [weak self] error in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self?.delegate?.didFailedGetPlace(response: error as? GoodBoyError ?? GoodBoyError())
        }
    }
}

