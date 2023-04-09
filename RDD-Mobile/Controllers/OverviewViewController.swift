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
    static var delegate: OverviewViewController?
    @IBOutlet weak var accessTable: UITableView!
    @IBOutlet weak var pointsCounter: UILabel!
    @IBOutlet weak var map: MKMapView!
    let store = DamagePointsStore()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var savingFrequency = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureMapAndLocation()
        self._configureDetailsSheet()
        OverviewViewController.delegate = self
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
        self.location = locations.last! as CLLocation
                
        let center = CLLocationCoordinate2D(
            latitude: self.location!.coordinate.latitude,
            longitude: self.location!.coordinate.longitude
        )
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        self.map.setRegion(region, animated: true)
    }
    
    func updateMarkers() {
        self.map.removeAnnotations(self.map.annotations)
        
        let markers = self.store.damagePoints.map({
            let point = MKPointAnnotation()
            point.title = "\($0.predictionsNumber)"
            point.coordinate = $0.location.coordinate
            return point
        })
        
        self.map.addAnnotations(markers)
    }
        
    private func _configureMapAndLocation() {
        self.overrideUserInterfaceStyle = .dark
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
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
            return 300
        }
        
        return (hiddenDetent, openDetent)
    }
}
