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
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        speechButton.isEnabled = false
        speechButton.isHidden = true
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
        }else if speechInput == "power down" {
            talk(wordsToSpeak: shutDown)
        }else if speechInput == "report" {
            talk(wordsToSpeak: reportON)
        } else {
            talk(wordsToSpeak: speechInput)
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

