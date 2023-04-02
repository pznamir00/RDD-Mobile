//
//  CameraViewController.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 02/04/2023.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var recordButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Camera"
    }
}
