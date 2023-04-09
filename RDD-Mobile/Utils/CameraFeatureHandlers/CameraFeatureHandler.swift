//
//  BaseHandler.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 09/04/2023.
//

import Foundation


protocol CameraFeatureHandler {
    var delegate: CameraViewController? { get set }
    var isProcessing: Bool { get set }
    var isLoading: Bool { get set }
    
    func setup(delegate: CameraViewController) -> Void
}
