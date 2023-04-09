import UIKit
import AVKit
import CoreLocation


class BottomSheetViewController : UIViewController, CLLocationManagerDelegate {
    static var delegate: BottomSheetViewController?
    @IBOutlet weak var locationIconRef: UIImageView!
    @IBOutlet weak var cameraIconRef: UIImageView!
    @IBOutlet weak var damagePointsNumberLabel: UILabel!
    private let locationManager = CLLocationManager()
    private var isCameraAvailable = false
    private var isLocationAvailable = false
    
    @IBAction func onClearDamagePointsFromStoreClick(_ sender: Any) {
        OverviewViewController.delegate?.store.damagePoints = []
    }
    
    @IBAction func onFrequencySliderChange(_ slider: UISlider) {
        OverviewViewController.delegate?.savingFrequency = Int(slider.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Overview"
                
        self.isCameraAvailable = self._checkIsCameraAvailable()
        self.isLocationAvailable = self._checkIsLocationAvailable()
        
        BottomSheetViewController.delegate = self
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
