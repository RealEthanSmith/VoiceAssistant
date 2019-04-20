//
//  bridgeDiscoveryController.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/19/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//
import Foundation
import UIKit

protocol PHBridgeDiscoveryControllerDelegate {
    func discoveryController(_ discoveryController:BridgeDiscoveryController, didFindBridges bridges:[PHBridgeInfo])
}

class BridgeDiscoveryController {
    var inProgress:Bool = false
    let alertHandler:AlertPresenting? = nil
    var delegate:PHBridgeDiscoveryControllerDelegate?
    lazy var bridgeDiscovery:PHSBridgeDiscovery = PHSBridgeDiscovery()
    
    func discoverBridges() {
        if inProgress {
            return;
        }
        
        inProgress = true;
        
        let options:PHSBridgeDiscoveryOption = PHSBridgeDiscoveryOption.discoveryOptionUPNP;
        bridgeDiscovery.search(options) { [weak self] (results, returnCode) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.inProgress = false
            
            if let results = results {
                if results.count > 0 {
                    let foundBridges:[PHBridgeInfo] = results.map({ (key, value) in PHBridgeInfoDiscoveryResult(withDiscoveryResult: value) })
                    strongSelf.delegate?.discoveryController(strongSelf, didFindBridges:foundBridges)
                    return
                }
            }
            strongSelf.showNoBridgesFoundAlert()
        }
    }
}

private typealias BridgeDiscoveryControllerAlerts = BridgeDiscoveryController
extension BridgeDiscoveryControllerAlerts {
    func showNoBridgesFoundAlert() {
        if let alertHandler = alertHandler {
            alertHandler.presentAlert(alert:noBridgesFoundAlert())
        }
    }
    
    func noBridgesFoundAlert() -> UIAlertController {
        let couldNotConnectAlert:UIAlertController = UIAlertController(title: NSLocalizedString("No bridges found", comment:"Title alert when no bridges found"),
                                                                       message: nil,
                                                                       preferredStyle:.alert)
        couldNotConnectAlert.addAction(alertActionForRetry())
        
        return couldNotConnectAlert
    }
    
    func alertActionForRetry() -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Retry", comment:"ry button on pushlink timeout"),
                             style:.default,
                             handler: { [weak self] (action) in
                                if let strongSelf = self {
                                    strongSelf.discoverBridges()
                                }
        })
    }
}
