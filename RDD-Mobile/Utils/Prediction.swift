//
//  Prediction.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 08/04/2023.
//

import Foundation
import Vision
import UIKit


class Prediction {
    private let rawPrediction: VNRecognizedObjectObservation
    
    init(rawPrediction: VNRecognizedObjectObservation) {
        self.rawPrediction = rawPrediction
    }
    
    func getPredictionBoxByDimensions(width: CGFloat, height: CGFloat) -> UIView {
        let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        let box = self.rawPrediction.boundingBox
        let transformedBox = box.applying(transform).applying(scale)
        return self._getBoxView(box: transformedBox)
    }
    
    private func _getBoxView(box: CGRect) -> UIView {
        let boxView = UIView(frame: box)
        boxView.layer.borderColor = PREDICTION_FRAME_COLOR.cgColor
        boxView.layer.borderWidth = 2
        boxView.backgroundColor = UIColor.clear
        return boxView
    }
}
