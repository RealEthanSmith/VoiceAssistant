//
//  PushLinkVC.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/19/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit

class PushLinkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidAppear(_ animated: Bool) {
        countdownUntilTimeout()
    }
    
    
    
    
    func countdownUntilTimeout() {
        let timeout:Float = 30
        var timeLeft = timeout
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            timeLeft -= 1
            let progress = timeLeft/timeout
            self.progressBar.progress = progress
            
            if timeLeft == 0 {
                self.timoutAlert()
                timer.invalidate()
            }
        }
    }
    
    func timoutAlert() {
        
        let alertController = UIAlertController(title: "Timeout", message: timeoutString, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }



}
