//
//  ViewController.swift
//  Project22
//
//  Created by Yulian Gyuroff on 5.11.23.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager!
    var beaconUUIDs = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable() {
                    //do stuff
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beakonRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeakon")
        locationManager?.startMonitoring(for: beakonRegion)
        locationManager?.startRangingBeacons(in: beakonRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
              case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            
            if isNewUUID(beacon: beacon){
                let ac = UIAlertController(title: "New beacon found", message: "uuid: \(beacon.uuid) Major.Minor: \(beacon.major),\(beacon.minor)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
                beaconUUIDs.append(beacon.uuid)
            }
            
        }else{
            update(distance: .unknown)
        }
    }
    
    func isNewUUID(beacon: CLBeacon) -> Bool {
        var isNew = true
        for uuid in beaconUUIDs {
            if String(describing: uuid) == String(describing: beacon.uuid) {
                isNew = false
            }
        }
        return isNew
    }
}

