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
        self.cameraHandler.setup(delegate: self)
        self.predictionHandler.setup(layerView: self.predictionLayerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraHandler.setRecording(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cameraHandler.setRecording(false)
    }
    
    func captureOutput(buffer: CVPixelBuffer?, t: CMTime) {
        self.predictionHandler.predict(buffer: buffer, t: t)
    }
}
