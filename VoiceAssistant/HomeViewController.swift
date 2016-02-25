//
//  ViewController.swift
//  VoiceAssistant
//
//  Created by 飞 刘 on 16/2/22.
//  Copyright © 2016年 飞 刘. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startApp(sender:UITapGestureRecognizer){
        self.performSegueWithIdentifier("StartApp", sender: self);
    }
}

