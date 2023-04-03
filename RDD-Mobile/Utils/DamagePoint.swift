//
//  DamagePoint.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 03/04/2023.
//

import Foundation
import CoreLocation


struct DetectedBoundingBox {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}


class DamagePoint {
    private var _detectedBoundingBoxes: [DetectedBoundingBox] = []
    private var _location: CLLocation
    
    var location: CLLocation {
        get { return self._location }
    }
    
    var holesNum: Int {
        get { return self._detectedBoundingBoxes.count }
    }
    
    init(location: CLLocation, boundingBoxes: [DetectedBoundingBox]) {
        self._location = location
        self._detectedBoundingBoxes = boundingBoxes
    }
}
