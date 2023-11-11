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
    @IBOutlet var uuidReading: UILabel!
    @IBOutlet var circleDistance: UIView!
    
    
    var locationManager: CLLocationManager!
    //var beaconUUIDs = [UUID]()
    var myBeacons = [MyBeacon]()
    var counter = 0
    var scanTimer: Timer?
    var i = 0
    var countForUnknown = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        circleDistance.layer.cornerRadius = 128
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
    
    @objc func startScanning() {
        // Testing with two beacons with same UUID and  different Major.Minor values
        let uuid2 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let uuid = UUID(uuidString: "10F86430-1346-11E4-9191-0800200C9A66")!
        let uuid3 = UUID(uuidString: "E48E8F52-14E7-45A9-AAF9-70A267C37DE3")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid, major: 456, minor: 123, identifier: "MyBeacon1")
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 123, minor: 456, identifier: "MyBeacon2")
        let beaconRegion3 = CLBeaconRegion(proximityUUID: uuid3, major: 321, minor: 654, identifier: "MyBeacon3")
        //let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid1, major: 120, minor: 450, identifier: "MyBeakon1")
        //let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        
        i += 1
            
        if i % 4 == 0 {
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)
            print("Scanning for beaconRegion")
        }else if i % 3 == 1 {
            locationManager?.startMonitoring(for: beaconRegion1)
            locationManager?.startRangingBeacons(in: beaconRegion1)
            print("Scanning for beaconRegion1")
        }else if i % 3 == 2 {
            locationManager?.startMonitoring(for: beaconRegion2)
            locationManager?.startRangingBeacons(in: beaconRegion2)
            print("Scanning for beaconRegion2")
        }else {
            locationManager?.startMonitoring(for: beaconRegion3)
            locationManager?.startRangingBeacons(in: beaconRegion3)
            print("Scanning for beaconRegion3")
        }
        //locationManager?.startRangingBeacons(satisfying: constraint)
        
        guard scanTimer == nil else { return }
        scanTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startScanning), userInfo: nil, repeats: true)
    }
    
    func update(distance: CLProximity, uuid: String, major: NSNumber, minor: NSNumber) {
        
        UIView.animate(withDuration: 1) {
            if uuid == "NotFound" {
                self.uuidReading.text = "\(uuid)"
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                //self.circleDistance.transform = .identity
                self.circleDistance.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }else{
                self.uuidReading.text = "\(uuid)\n\(major).\(minor)"
                switch distance {
                  case .far:
                    self.view.backgroundColor = .blue
                    self.distanceReading.text = "FAR"
                    //self.circleDistance.transform = .identity
                    self.circleDistance.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                case .near:
                    self.view.backgroundColor = .orange
                    self.distanceReading.text = "NEAR"
                    //self.circleDistance.transform = .identity
                    self.circleDistance.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                case .immediate:
                    self.view.backgroundColor = .red
                    self.distanceReading.text = "RIGHT HERE"
                    //self.circleDistance.transform = .identity
                    self.circleDistance.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                default:
    //                self.view.backgroundColor = .gray
    //                self.distanceReading.text = "UNKNOWN"
                    print("")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        counter += 1
        print("Iteration: \(counter) beacons.count: \(beacons.count)")
        if beacons.count == 0 {
            countForUnknown += 1
            if countForUnknown > 12 {
                countForUnknown = 0
                update(distance: .unknown, uuid: "NotFound", major: 0, minor: 0)
            }
            
            return
            
        }
        
//        if let beacon = beacons.first {
//
//            update(distance: beacon.proximity, uuid: String(describing: beacon.uuid ),
//                   major: beacon.major, minor: beacon.minor)
//
//            if isNewUUID(beacon: beacon){
//                let ac = UIAlertController(title: "New beacon found", message: "uuid: \(beacon.uuid) Major.Minor: \(beacon.major),\(beacon.minor)", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
//                present(ac, animated: true)
//                myBeacons.append(MyBeacon(uuid: String(describing: beacon.uuid), major: beacon.major, minor: beacon.minor))
//            }
//
//        }else{
//            update(distance: .unknown, uuid: "NotFound", major: 0, minor: 0)
//        }
        
        if beacons.count > 0 {
            
            for beacon in beacons {
                update(distance: beacon.proximity, uuid: String(describing: beacon.uuid ),
                       major: beacon.major, minor: beacon.minor)
                
                if isNewUUID(beacon: beacon){
                    let ac = UIAlertController(title: getBeaconName(beacon: beacon), message: "uuid: \(beacon.uuid) Major.Minor: \(beacon.major),\(beacon.minor)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(ac, animated: true)
                    myBeacons.append(MyBeacon(uuid: String(describing: beacon.uuid), major: beacon.major, minor: beacon.minor))
                    print("\(getBeaconName(beacon: beacon)) - added: uuid: \(beacon.uuid) major: \(beacon.major) minor: \(beacon.minor)")
                }
            }
        }else{
            update(distance: .unknown, uuid: "NotFound", major: 0, minor: 0)
        }
    }
    
    func isNewUUID(beacon: CLBeacon) -> Bool {
        var isNew = true
        for item in myBeacons {
            if String(describing: item.uuid) == String(describing: beacon.uuid) &&
                    item.major == beacon.major && item.minor == beacon.minor  {
                isNew = false
            }
        }
        return isNew
    }
    
    func getBeaconName(beacon: CLBeacon) -> String {
        var beaconName = "UNKNOWN"
        
        if String(describing: beacon.uuid) == "10F86430-1346-11E4-9191-0800200C9A66" &&
            beacon.major == 123 && beacon.minor == 456 {
            beaconName = "MyBeacon found"
        }
        if String(describing: beacon.uuid) == "10F86430-1346-11E4-9191-0800200C9A66" &&
            beacon.major == 456 && beacon.minor == 123 {
            beaconName = "MyBeacon1 found"
        }
        if String(describing: beacon.uuid) == "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5" &&
            beacon.major == 123 && beacon.minor == 456 {
            beaconName = "MyBeacon2 found"
        }
        if String(describing: beacon.uuid) == "E48E8F52-14E7-45A9-AAF9-70A267C37DE3" &&
            beacon.major == 321 && beacon.minor == 654 {
            beaconName = "MyBeacon3 found"
        }
        return beaconName
    }
}

