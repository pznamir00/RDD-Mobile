import UIKit
import AVKit
import CoreLocation


class DetailsModalViewController : UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationIconRef: UIImageView!
    @IBOutlet weak var cameraIconRef: UIImageView!
    private let locationManager = CLLocationManager()
    private var isCameraAvailable = false
    private var isLocationAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Overview"
                
        self.isCameraAvailable = self._checkIsCameraAvailable()
        self.isLocationAvailable = self._checkIsLocationAvailable()
        
        self._setImageViewColorBaseOnCondition(
            view: self.cameraIconRef,
            condition: self.isCameraAvailable
        )
        self._setImageViewColorBaseOnCondition(
            view: self.locationIconRef,
            condition: self.isLocationAvailable
        )
    }
    
    private func _setImageViewColorBaseOnCondition(view: UIImageView, condition: Bool){
        view.tintColor = condition ? FEATURE_AVAILABLE_COLOR : FEATURE_UNAVAILABLE_COLOR
    }
    
    private func _checkIsCameraAvailable() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            return true
        } else {
            var granted = false
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_granted: Bool) -> Void in
               granted = _granted
           })
            return granted
        }
    }
    
    private func _checkIsLocationAvailable() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }
        return [
            .authorizedAlways,
            .authorizedWhenInUse
        ].contains(CLLocationManager.authorizationStatus())
    }
}
