//
//  OverviewViewController.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 02/04/2023.
//

import UIKit
import MapKit
import Vision
import CoreMedia


class OverviewViewController: UIViewController {
    @IBOutlet weak var accessTable: UITableView!
    @IBOutlet weak var pointsCounter: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureMap()
        
        self.showTableView()
    }
    
    private func _configureMap() -> Void {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50, longitude: 14),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        self.map.setRegion(region, animated: true)
    }
    
    func showTableView(){
        let details = DetailsModalViewController()
        details.isModalInPresentation = true
        
        if let sheet = details.sheetPresentationController {
            let superSmallDetent = self._getSuperSmallDetent()
            sheet.detents = [superSmallDetent, .medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.selectedDetentIdentifier = superSmallDetent.identifier
            sheet.preferredCornerRadius = 20
        }
        
        self.present(details, animated: true)
    }
    
    private func _getSuperSmallDetent() -> UISheetPresentationController.Detent {
        let id = UISheetPresentationController.Detent.Identifier("superSmall")
        return UISheetPresentationController.Detent.custom(identifier: id) { context in
            return 10
        }
    }
}
