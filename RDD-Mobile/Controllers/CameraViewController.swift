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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Camera"
        self.cameraHandler.setup(context: self)
        self.predictionHandler.setup(context: self.predictionLayerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraHandler.setProcessing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cameraHandler.setProcessing(false)
    }
    
    func captureOutput(buffer: CVPixelBuffer?) {
        return self.predictionHandler.predict(buffer: buffer)
    }
}
