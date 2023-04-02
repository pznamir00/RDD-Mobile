//
//  OverviewViewController.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 02/04/2023.
//

import UIKit
import MapKit

class OverviewViewController: UIViewController {
    @IBOutlet weak var locationAccessIconRef: UIImageView!
    @IBOutlet weak var cameraAccessIconRef: UIImageView!
    @IBOutlet weak var internetConnectionIconRef: UIImageView!
    @IBOutlet weak var pointsCounter: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Overview"
    }
    
}
