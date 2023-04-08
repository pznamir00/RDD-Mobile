//
//  ModelHandler.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 04/04/2023.
//

import Foundation
import CoreMedia
import Vision


class PredictionHandler {
    private var layer: PredictionLayerView?
    private var request: VNCoreMLRequest?
    private var isPredicting = false
    private let semaphore = DispatchSemaphore(value: 1)
    
    func setup(layerView: PredictionLayerView){
        self.layer = layerView
        self._loadModel()
    }
    
    func predict(buffer: CVPixelBuffer?, t: CMTime) {
        if self.request != nil, !self.isPredicting, let pixelBuffer = buffer {
            self.isPredicting = true
            guard let req = self.request else { fatalError() }
            self.semaphore.wait()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try? handler.perform([req])
        }
    }
    
    private func _loadModel() {
        if #available(iOS 14.0, *) {
            if let model = try? VNCoreMLModel(for: holesDetection().model) {
                self.request = VNCoreMLRequest(
                    model: model,
                    completionHandler: self._onPredictionComplete
                )
                return
            }
        }
        
        fatalError("fail to create vision model")
    }
    
    private func _onPredictionComplete(request: VNRequest, error: Error?) {
        if let rawPredictions = request.results as? [VNRecognizedObjectObservation] {
            let predictions = rawPredictions.map({ Prediction(rawPrediction: $0) })
            DispatchQueue.main.async {
                self.layer!.draw(predictions: predictions)
                self.isPredicting = false
            }
        } else {
            self.isPredicting = false
        }
        
        self.semaphore.signal()
    }
}
