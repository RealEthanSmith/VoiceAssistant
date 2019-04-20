//
//  ViewController.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/17/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {
    
    @IBOutlet weak var voiceWords: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var speechButton: CircleButton!
    
    let speakTalk = AVSpeechSynthesizer()
    var lowercaseInput: String!
    var bridge: PHSBridge! = nil
    var PushLinkVC: PushLinkVC? = nil
    var lastConnectedBridge: PHBridgeInfo? {
        get {
            if let lastConnectedBridge: PHSKnownBridge = PHSKnownBridge.lastConnectedBridge {
                let bridge = PHBridgeInfo(ipAddress: lastConnectedBridge.ipAddress, uniqueID: lastConnectedBridge.uniqueId)
                return bridge
            }
            return nil
        }
    }
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        speechButton.isEnabled = false
        speechButton.isHidden = true
    }
    
    //View did Appear -- Bridge Connection
    override func viewDidAppear(_ animated: Bool) {
        guard selectedBridge == nil else {
            bridge = buildBridge(with: selectedBridge!)
            bridge.connect()
            return
        }
        
        guard lastConnectedBridge == nil else {
            bridge = buildBridge(with: lastConnectedBridge!)
            bridge.connect()
            return
        }
        self.performSegue(withIdentifier: "showBridgeSelection", sender: self)
    }
    
    func buildBridge(with info: PHBridgeInfo) -> PHSBridge{
        return.init(block: { (builder) in
            builder?.connectionTypes = .local
            builder?.ipAddress = info.ipAddress
            builder?.bridgeID = info.uniqueID
            
            builder?.bridgeConnectionObserver = self
            builder?.add(self)
        }, withAppName: "V-Assist", withDeviceName: "Emmett's iPhone")
    }
    
    func handleAuth() {
        if let pushVC = PushLinkVC {
            pushVC.dismiss(animated: true, completion: nil)
        }
    }
    func handleNoAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PushLinkID")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    //Main Button
    @IBAction func pressForVoice(_ sender: Any) {
        if voiceWords.text != nil {
            lowercaseInput = voiceWords.text!.lowercased()
             reactToInput(speechInput: lowercaseInput)
        } else if voiceWords.text == nil || voiceWords.text == ""{
             talk(wordsToSpeak: defaultTalk)
        }
    }
    
    //Functions for the App
    func talk(wordsToSpeak: String){
        let MrSmith = AVSpeechUtterance(string: wordsToSpeak)
        MrSmith.pitchMultiplier = 0.5
        speakTalk.speak(MrSmith)
    }
    func reactToInput(speechInput: String){
        if speechInput == "power up" {
            talk(wordsToSpeak: turnOn)
            lightsNowOn()
        }else if speechInput == "power down" {
            talk(wordsToSpeak: shutDown)
            lightsNowOff()
        }else if speechInput == "report" {
            talk(wordsToSpeak: reportON)
        } else {
            talk(wordsToSpeak: speechInput)
        }
    }
    func lightsOn() -> PHSLightState {
        let lightState = PHSLightState()
        lightState.on = true
        
        return lightState
    }
    func lightsOff() -> PHSLightState {
        let lightState = PHSLightState()
        lightState.on = false
        
        return lightState
    }
    
    func lightsNowOn(){
        if let devices = bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices{
                if let lightPoint = device as? PHSLightPoint {
                    let lightSate = self.lightsOn()
                    
                    lightPoint.update(lightSate, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        if errors != nil{
                            for error in errors!{
                                print(error.debugDescription)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func lightsNowOff(){
        if let devices = bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices{
                if let lightPoint = device as? PHSLightPoint {
                    let lightSate = self.lightsOff()
                    
                    lightPoint.update(lightSate, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        if errors != nil{
                            for error in errors!{
                                print(error.debugDescription)
                            }
                        }
                    })
                }
            }
        }
    }

//    func requestSpeechAuth() {
//        SFSpeechRecognizer.requestAuthorization { AVAuthorizationStatus in
//            if AVAuthorizationStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
//
//            }
//        }
//    }
    
}
