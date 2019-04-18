//
//  ViewController.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/17/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var voiceWords: UITextField!
    @IBOutlet weak var button: UIButton!
    let speakTalk = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressForVoice(_ sender: Any) {
        talk(wordsToSpeak: voiceWords.text!)
    }
    
    
    func talk(wordsToSpeak: String){
        let MrSmith = AVSpeechUtterance(string: wordsToSpeak)
        MrSmith.pitchMultiplier = 0.5
        speakTalk.speak(MrSmith)
    }
    
}

