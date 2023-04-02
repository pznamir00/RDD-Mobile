//
//  CameraHandler.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 02/04/2023.
//

import Foundation
import UIKit
import AVFoundation
import CoreVideo


class CameraHandler: NSObject {
    private var isRecording = false
    private let session = AVCaptureSession()
    private var output: AVCaptureVideoDataOutput
    private var layer: AVCaptureVideoPreviewLayer
    
    func onInit(){
        self.session.beginConfiguration()
        self.session.sessionPreset = .vga640x480
        
        self._loadLayer()
        self._loadAVInput()
        self._loadOutput()
        
        self.session.commitConfiguration()
    }
    
    func setRecording(value: Bool) -> Void {
        if value {
            self.session.startRunning()
        } else {
            self.session.stopRunning()
        }
    }
    
    private func _loadLayer() {
        self.layer = AVCaptureVideoPreviewLayer(session: self.session)
        self.layer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.layer.connection?.videoOrientation = .portrait
    }
    
    private func _loadAVInput() -> Void {
        let device = self._getAVDevice()
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            fatalError("Failed to create input")
        }
        
        if self.session.canAddInput(input) {
            self.session.addInput(input)
        }
    }
    
    private func _loadOutput() -> Void {
        self.output = AVCaptureVideoDataOutput()
        self.output.alwaysDiscardsLateVideoFrames = true
        self.output.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        }
    }
    
    private func _getAVDevice() -> AVCaptureDevice {
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else {
            fatalError("No camera available")
        }
        return device
    }
}
