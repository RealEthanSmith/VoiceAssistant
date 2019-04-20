//
//  UniversalThings.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/17/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import UIKit

var wordsToTalk = "Hello, my Name is Mr.Smith. If you are hearing this message, please fix the code. Goodbye..."
let defaultTalk = "Hello user. No string was given. Try again..."
let shutDown = "Understood... Systems powering down"
let turnOn = "Understood... All systems now online"
let reportON = "Power consumption, stable...Lighting, online...Security Systems, online"
let reportOFF = "Power consumption, not availiable...Lighting, offline...Security Systems, offline...Optimal Proceeding command, power up"
let timeoutString = "Bridge took too long to respond"

var selectedBridge: PHBridgeInfo? = nil


//Extension 1 - Connection Obersver
extension ViewController: PHSBridgeConnectionObserver {
    func bridgeConnection(_ bridgeConnection: PHSBridgeConnection!, handle connectionEvent: PHSBridgeConnectionEvent) {
        
        switch connectionEvent {
        case .connected:
            break
        case .authenticated:
            handleAuth()
            break
        case .linkButtonNotPressed:
            break
        case .notAuthenticated:
            handleNoAuth()
            break
        default:
            return
        }
        
    }
    
    func bridgeConnection(_ bridgeConnection: PHSBridgeConnection!, handleErrors connectionErrors: [PHSError]!) {
        //
    }
    
    
}

//Extension 2 - State Update Observer
extension ViewController: PHSBridgeStateUpdateObserver {
    func bridge(_ bridge: PHSBridge!, handle updateEvent: PHSBridgeStateUpdatedEvent) {
        
        switch updateEvent {
        case .bridgeConfig:
            break
        case .fullConfig:
            break
        case .initialized:
            break
        default:
            return
        }
        
    }
}


extension PHSKnownBridge {
    class var lastConnectedBridge: PHSKnownBridge? {
        get {
            
            
            let knownBridges: [PHSKnownBridge] = PHSKnownBridges.getAll()
            let sortedKnownBridges: [PHSKnownBridge] = knownBridges.sorted { (bridge1, bridge2) -> Bool in
                return bridge1.lastConnected < bridge2.lastConnected
            }
            return sortedKnownBridges.first
            
            
        }
    }
}

//Alert Presenting Start
protocol AlertPresenting {
    func presentAlert(alert:UIAlertController)
    func dismissAlerts()
}

extension AlertPresenting where Self : UIViewController {
    func presentAlert(alert:UIAlertController) {
        dismissAlerts()
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlerts() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
//Alert Presenting End
