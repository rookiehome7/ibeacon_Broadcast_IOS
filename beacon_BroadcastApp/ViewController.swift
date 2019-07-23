//
//  ViewController.swift
//  becon_BroadcastApp
//
//  Created by Takdanai Jirawanichkul on 20/7/2562 BE.
//  Copyright © 2562 Takdanai Jirawanichkul. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var uuidValue: UILabel!
    @IBOutlet weak var majorValue: UILabel!
    @IBOutlet weak var minorValue: UILabel!
    @IBOutlet weak var identityValue: UILabel!
    @IBOutlet weak var beaconStatus: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Objects used in the creation of iBeacons
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    let localBeaconUUID = "7D0D9B66-0554-4CCF-A6E4-ADE12325C4F0"
    let localBeaconMajor: CLBeaconMajorValue = 123
    let localBeaconMinor: CLBeaconMinorValue = 789
    let identifier = "Put your identifier here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopButton.isHidden = true
        // UI setup
        uuidValue.text = localBeaconUUID
        majorValue.text = String(localBeaconMajor)
        minorValue.text = String(localBeaconMinor)
        identityValue.text = identifier
        beaconStatus.text = "OFF"
    }

    @IBAction func startButton(_ sender: Any) {
        initLocalBeacon()
        startButton.isHidden = true
        stopButton.isHidden = false
        beaconStatus.text = "ON"
    }
    @IBAction func stopButton(_ sender: Any) {
        stopLocalBeacon()
        startButton.isHidden = false
        stopButton.isHidden = true
        beaconStatus.text = "OFF"
    }
    
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: identifier)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
            
        }
        else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    

}

