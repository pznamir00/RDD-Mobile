import UIKit
import AVKit
import CoreLocation


class DetailsModalViewController : UIViewController {
    @IBOutlet weak var locationIconRef: UIImageView!
    @IBOutlet weak var cameraIconRef: UIImageView!
    private let locationManager = CLLocationManager()
    private var isCameraAvailable = false
    private var isLocationAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Overview"
        self.isCameraAvailable = self._checkIsCameraavailable()
        self.isLocationAvailable = self._checkIsLocationAvailable()
        self._updateIconsTintColors()
    }
    
    private func _updateIconsTintColors(){
        self.cameraIconRef.tintColor = self.isCameraAvailable ? UIColor.blue : UIColor.red
        self.locationIconRef.tintColor = self.isLocationAvailable ? UIColor.blue : UIColor.red
    }
    
    private func _checkIsCameraavailable() -> Bool {
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
        if CLLocationManager.locationServicesEnabled() {
            switch self.locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                @unknown default:
                    break
            }
        }
        
        return false
    }
}
