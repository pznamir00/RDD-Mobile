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
        self._configureDetailsSheet()
    }
    
    private func _configureMap() -> Void {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50, longitude: 14),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        
        self.map.setRegion(region, animated: true)
    }
    
    private func _configureDetailsSheet(){
        let details = self.storyboard?.instantiateViewController(identifier: "testSB")
        details!.isModalInPresentation = true
        
        if let sheet = details!.sheetPresentationController {
            let (hiddenDetent, openDetent) = self._getCustomDetents()
            sheet.detents = [hiddenDetent, openDetent]
            sheet.largestUndimmedDetentIdentifier = openDetent.identifier
            sheet.selectedDetentIdentifier = hiddenDetent.identifier
            sheet.preferredCornerRadius = 20
        }
        
        self.present(details!, animated: true)
    }
    
    private func _getCustomDetents() -> (UISheetPresentationController.Detent, UISheetPresentationController.Detent) {
        let hiddenDetentId = UISheetPresentationController.Detent.Identifier("hiddenDetent")
        let hiddenDetent = UISheetPresentationController.Detent.custom(identifier: hiddenDetentId) { context in
            return 10
        }
        
        let openDetentId = UISheetPresentationController.Detent.Identifier("openDetent")
        let openDetent = UISheetPresentationController.Detent.custom(identifier: openDetentId) { context in
            return 200
        }
        
        return (hiddenDetent, openDetent)
    }
}
