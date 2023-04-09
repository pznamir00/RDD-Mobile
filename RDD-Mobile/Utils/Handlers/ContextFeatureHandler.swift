//
//  BaseHandler.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 09/04/2023.
//

import Foundation


protocol ContextFeatureHandler {
    associatedtype T
    
    var context: T? { get set }
    var isProcessing: Bool { get set }
    var isLoading: Bool { get set }
    
    func setup(context: T) -> Void
}
