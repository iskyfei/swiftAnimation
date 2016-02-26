//
//  LeRecorderViewController.swift
//  VoiceAssistant
//
//  Created by 飞 刘 on 16/2/23.
//  Copyright © 2016年 飞 刘. All rights reserved.
//

import Foundation
import UIKit

class LeRecorderViewController: LeViewController {
    
    @IBOutlet weak var micIcon: CCMRadarView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         self.startAnimation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAnimation() {
        
        micIcon?.startAnimation()
//        micIcon?.startScale()
        
    }
    
    @IBAction func doTest(){
        micIcon?.stopAnimation();
        self.performSegueWithIdentifier("doRecognition", sender: self);
    }
    
}