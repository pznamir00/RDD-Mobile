//
//  CameraViewController.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 02/04/2023.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var predictionLayerView: PredictionLayerView!
    private let cameraHandler = CameraHandler()
    private let predictionHandler = PredictionHandler()
    private var savingToStoreAction: DebounceAction<[Prediction]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Camera"
        self.cameraHandler.setup(delegate: self)
        self.predictionHandler.setup(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let f = CGFloat(OverviewViewController.delegate!.savingFrequency)
        self.initializeSavingToStoreAction(debouceTime: f)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraHandler.setProcessing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cameraHandler.setProcessing(false)
    }
    
    func initializeSavingToStoreAction(debouceTime: CGFloat) {
        self.savingToStoreAction = DebounceAction(debouceTime) { value in
            if let loc = OverviewViewController.delegate!.location, value.count > 0 {
                let store = OverviewViewController.delegate!.store
                store.addPoint(predictions: value, location: loc)
            }
        }
    }
    
    func captureOutput(buffer: CVPixelBuffer?) {
        return self.predictionHandler.predict(buffer: buffer)
    }
    
    func onPredictionComplete(predictions: [Prediction]) {
        self.predictionLayerView.draw(predictions: predictions)
        self.savingToStoreAction?.emit(value: predictions)
    }
}
