//
//  DamagePointsStore.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 09/04/2023.
//

import Foundation
import CoreLocation


class DamagePointsStore {
    var damagePoints: [DamagePoint] = [] {
        didSet {
            OverviewViewController.delegate?.updateMarkers()
            BottomSheetViewController.delegate?.damagePointsNumberLabel.text = "\(self.damagePoints.count)"
        }
    }
    
    func addPoint(predictions: [Prediction], location: CLLocation) {
        let damagePoint = DamagePoint(predictions: predictions, location: location)
        self.damagePoints.append(damagePoint)
    }
}


class DamagePoint {
    private let predictions: [Prediction]
    let location: CLLocation
    
    var predictionsNumber: Int {
        get { return self.predictions.count }
    }
    
    init(predictions: [Prediction], location: CLLocation) {
        self.predictions = predictions
        self.location = location
    }
}
