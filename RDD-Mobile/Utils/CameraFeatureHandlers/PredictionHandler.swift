//
//  ModelHandler.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 04/04/2023.
//

import Foundation
import CoreMedia
import Vision


class PredictionHandler: CameraFeatureHandler {
    private var request: VNCoreMLRequest?
    private let semaphore = DispatchSemaphore(value: 1)
    internal var isProcessing = false
    internal var isLoading = true
    internal var delegate: CameraViewController?
    
    internal func setup(delegate: CameraViewController){
        self.delegate = delegate

        if #available(iOS 14.0, *) {
            if let model = try? VNCoreMLModel(for: holesDetection().model) {
                self.request = VNCoreMLRequest(
                    model: model,
                    completionHandler: self._onPredictionComplete
                )
                self.isLoading = false
                return
            }
        }
        
        fatalError("Failed to load model")
    }
    
    func predict(buffer: CVPixelBuffer?) {
        if self.request != nil, !self.isProcessing, let pixelBuffer = buffer {
            self.isProcessing = true
            guard let req = self.request else { fatalError() }
            self.semaphore.wait()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try? handler.perform([req])
        }
    }
    
    private func _onPredictionComplete(request: VNRequest, error: Error?) {
        if let rawPredictions = request.results as? [VNRecognizedObjectObservation] {
            let predictions = rawPredictions.map({ Prediction(rawPrediction: $0) })
            DispatchQueue.main.async {
                self.delegate!.onPredictionComplete(predictions: predictions)
                self.isProcessing = false
            }
        } else {
            self.isProcessing = false
        }
        
        self.semaphore.signal()
    }
}
