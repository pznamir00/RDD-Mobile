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
import Combine


class CameraHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var isRecording = false
    private let session = AVCaptureSession()
    private let output = AVCaptureVideoDataOutput()
    private var subscription = Set<AnyCancellable>()
    private let publisher = PassthroughSubject<CMSampleBuffer, Never>()
    var layer: AVCaptureVideoPreviewLayer?
    var delegate: CameraViewController?


    func setup(delegate: CameraViewController) {
        self.delegate = delegate
        
        self.session.beginConfiguration()
        self.session.sessionPreset = .vga640x480
        
        self._loadInput()
        self._loadLayer()
        self._loadOutput()
                
        self.session.commitConfiguration()
        
        self.bindWithView(cameraView: delegate.cameraView)
        self.setRecording(true)
        
        
        self.publisher
            .throttle(
                for: .seconds(1 / FPS),
                scheduler: DispatchQueue.main,
                latest: true
            )
            .sink { buffer in
                let imgBuff = CMSampleBufferGetImageBuffer(buffer)
                self.delegate?.captureOutput(buffer: imgBuff)
            }
            .store(in: &self.subscription)
    }
    
    func bindWithView(cameraView: UIView) {
        if let _layer = self.layer {
            cameraView.layer.addSublayer(_layer)
            self.layer!.frame = cameraView.bounds
        }
    }
    
    func setRecording(_ value: Bool) -> Void {
        if value {
            self.session.startRunning()
        } else {
            self.session.stopRunning()
        }
    }
    
    func captureOutput(_ out: AVCaptureOutput, didOutput bfr: CMSampleBuffer, from conn: AVCaptureConnection) {
        self.publisher.send(bfr)
    }
    
    private func _loadInput() -> Void {
        let device = self._getAVDevice()

        guard let input = try? AVCaptureDeviceInput(device: device) else {
            fatalError("Failed to create input")
        }

        if self.session.canAddInput(input) {
            self.session.addInput(input)
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
    
    private func _loadLayer() {
        self.layer = AVCaptureVideoPreviewLayer(session: self.session)
        self.layer!.videoGravity = AVLayerVideoGravity.resizeAspect
        self.layer!.connection!.videoOrientation = .portrait
    }
    
    private func _loadOutput() -> Void {
        self.output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(
                value: kCVPixelFormatType_32BGRA
            )
        ]
        self.output.alwaysDiscardsLateVideoFrames = true
        self.output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "queue"))

        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        }

        self.output.connection(with: .video)!.videoOrientation = .portrait
    }
}
