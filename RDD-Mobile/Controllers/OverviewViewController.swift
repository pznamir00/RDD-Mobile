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
import CoreLocation


class OverviewViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var accessTable: UITableView!
    @IBOutlet weak var pointsCounter: UILabel!
    @IBOutlet weak var map: MKMapView!
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureMapAndLocation()
        self._configureDetailsSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let location = locations.last! as CLLocation
                
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        self.map.setRegion(region, animated: true)
    }
    
    private func _configureMapAndLocation() {
        self.overrideUserInterfaceStyle = .dark
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func _configureDetailsSheet(){
        let details = self.storyboard?.instantiateViewController(identifier: "bottomSheet")
        details!.isModalInPresentation = true
        
        if let sheet = details!.sheetPresentationController {
            let (hiddenDetent, openDetent) = self._getCustomDetents()
            sheet.detents = [hiddenDetent, openDetent]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = openDetent.identifier
            sheet.selectedDetentIdentifier = hiddenDetent.identifier
            sheet.preferredCornerRadius = 20
        }
        
        self.present(details!, animated: true)
    }
    
    private func _getCustomDetents() -> (UISheetPresentationController.Detent, UISheetPresentationController.Detent) {
        let hiddenDetentId = UISheetPresentationController.Detent.Identifier("hiddenDetent")
        let hiddenDetent = UISheetPresentationController.Detent.custom(identifier: hiddenDetentId) { context in
            return 50
        }
        
        let openDetentId = UISheetPresentationController.Detent.Identifier("openDetent")
        let openDetent = UISheetPresentationController.Detent.custom(identifier: openDetentId) { context in
            return 200
        }
        
        return (hiddenDetent, openDetent)
    }
}
