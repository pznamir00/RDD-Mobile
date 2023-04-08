//
//  PredictionLayerView.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 08/04/2023.
//

import Foundation
import UIKit
import Vision

class PredictionLayerView: UIView {
    var dimensions: (CGFloat, CGFloat) {
        get {
            return (self.bounds.width, self.bounds.height)
        }
    }
    
    func draw(predictions: [Prediction]) {
        self._clearSubViews()
        self._createPredictionFrames(predictions: predictions)
        self.setNeedsDisplay()
    }
    
    private func _clearSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func _createPredictionFrames(predictions: [Prediction]) {
        let (W, H) = self.dimensions
        
        predictions.forEach({
            let frame = $0.getPredictionBoxByDimensions(width: W, height: H)
            self.addSubview(frame)
        })
    }
}
