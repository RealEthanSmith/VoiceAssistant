//
//  BridgeSelectionVC.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/19/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit

class BridgeSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var bridges: [PHBridgeInfo] = []
    lazy var bridgeDiscovery:PHSBridgeDiscovery = PHSBridgeDiscovery()
    var delegate:PHBridgeDiscoveryControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityInicator: UIActivityIndicatorView!
    
    lazy var bridgeDiscoveryController = {
        return BridgeDiscoveryController()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        discoverBridges()
        countdownUntilRefresh()
    }
    
    //Refresh Button
    @IBAction func refresh(_ sender: Any) {
        discoverBridges()
        countdownUntilRefresh()
    }
    
    func countdownUntilRefresh() {
        let timeout:Float = 20
        var timeLeft = timeout
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            timeLeft -= 1
            
            if timeLeft == 0 {
               self.timoutAlert()
                timer.invalidate()
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    //TableView Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bridges.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "BridgeCell", for: indexPath)
        let bridge = bridges[indexPath.row]
        
        cell.textLabel?.text = bridge.ipAddress
        cell.detailTextLabel?.text = bridge.uniqueID
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBridge = bridges[indexPath.row]
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
//    func discoverBridges() {
//        self.bridgeDiscoveryController.discoverBridges()
//    }
    func discoverBridges() {
        let options: PHSBridgeDiscoveryOption = .discoveryOptionUPNP
        let bridgeDiscovery = PHSBridgeDiscovery()

        bridgeDiscovery.search(options) { (result, returnCode) in

            if returnCode == .success {
                self.bridges.removeAll()

                for (_, value) in result! {
                    let bridgeInfo = PHBridgeInfo(ipAddress: value.ipAddress, uniqueID: value.uniqueId)
                    self.bridges.append(bridgeInfo)
                }
                self.tableView.reloadData()
            }


        }
    }
    
    
    
    
    
    func noBridgesFoundAlert() {
        
        let alertController = UIAlertController(title: "No bridges found", message: "No bridges were found", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.discoverBridges()
            self.countdownUntilRefresh()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    func timoutAlert() {
        
        let alertController = UIAlertController(title: "Done Searching", message: "Press OK", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.refreshTableView()
        }
        
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func refreshTableView(){
        self.tableView.reloadData()
        if bridges.count == 1 {
            print(bridges[1].ipAddress)
        }else {
            print("Count: \(bridges.count)")
            noBridgesFoundAlert()
        }
    }

    
}

