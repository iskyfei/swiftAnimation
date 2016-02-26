//
//  LeRecognizeViewController.swift
//  VoiceAssistant
//
//  Created by 飞 刘 on 16/2/24.
//  Copyright © 2016年 飞 刘. All rights reserved.
//

import UIKit


private enum LeRecgViewStatus:UInt{
    case NORMAL
    case MAX
    case MIN
}

class LeRecognizeViewController: LeViewController {
    private var normalHeightForBottomView:CGFloat!
    private var maxHeightForBottomView: CGFloat!
    private var minHeightForBottomView: CGFloat!
    private var deltaHeightForPanChange: CGFloat!
    
    private var originalHeightOfBottomView: CGFloat!
    private  var curViewStatus:LeRecgViewStatus = LeRecgViewStatus.NORMAL
    
    private var topPanGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var heightConstraintOfBottomView: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gestureView : UIView!
    @IBOutlet weak var micBtn: UIButton!
    
    @IBOutlet weak var loadingView: LeLoadingAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        normalHeightForBottomView = heightConstraintOfBottomView.constant
        maxHeightForBottomView = self.view.frame.height;
        minHeightForBottomView = 0
        deltaHeightForPanChange = topView.frame.height/2
        
        originalHeightOfBottomView = self.view.bounds.height * 2 / 3
        heightConstraintOfBottomView.constant = self.view.bounds.height / 3
        curViewStatus = LeRecgViewStatus.NORMAL
        
        topPanGesture = UIPanGestureRecognizer.init(target: self, action: Selector("handlePanGesture:"))
        
        micBtn.bringSubviewToFront(bottomView)
       
        contentView.layer.masksToBounds = true
        
        topView.bringSubviewToFront(micBtn)
        
        loadingView.kRadius = 70.0
        loadingView.kLineLong = 15.0
        loadingView.likeColor = UIColor(red: 0.153, green: 0.784, blue: 0.788, alpha: 1.00)
        
        loadingView.start()
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Int64(NSEC_PER_SEC)))
        
        dispatch_after(delay, dispatch_get_main_queue()) {[weak self] () -> Void in
            self?.loadingView.stop()
            self?.handleLoadingEndAction()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePanGesture(gesture :UIPanGestureRecognizer){
        let y:CGFloat = gesture.translationInView(self.view).y
        
        
        if (gesture.state != UIGestureRecognizerState.Ended){
            heightConstraintOfBottomView.constant = originalHeightOfBottomView - y
            
            print("drag offset.y: \(y) + height constant: \(heightConstraintOfBottomView.constant)")
            return
        }
        
        /// pan gesture end
        
        print("drag end offset.y: \(y) + dh: \(deltaHeightForPanChange)")
        
        var targetHeight  = originalHeightOfBottomView
        
        if(abs(y) > deltaHeightForPanChange){
            if (y > 0){
                // to down
                switch curViewStatus{
                case .NORMAL:
                    targetHeight = minHeightForBottomView
                    curViewStatus = .MIN
                    
                case .MAX:
                    targetHeight = normalHeightForBottomView
                    curViewStatus = .NORMAL
                case .MIN:
                     assert(false, "should not happen. controller has been changed")
                }
            }
            else{
                // to up
                switch curViewStatus{
                case .NORMAL:
                    targetHeight = maxHeightForBottomView
                    curViewStatus = .MAX
                case .MAX:
                    targetHeight = maxHeightForBottomView
                case .MIN:
                    assert(false, "should not happen. controller has been changed")
                    targetHeight = normalHeightForBottomView
                    curViewStatus = .NORMAL
                }
            }
        }
        
        self.heightConstraintOfBottomView.constant = targetHeight
        UIView.animateWithDuration(0.5, animations: {[weak self] () -> Void in
            self?.view.layoutIfNeeded()
            }) {[weak self] (finished:Bool) -> Void in
                self?.originalHeightOfBottomView = self!.heightConstraintOfBottomView.constant
                if(self?.curViewStatus == .MIN){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self?.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
        }
        
        return
    }
    
    private func handleLoadingEndAction(){
        topView.addGestureRecognizer(topPanGesture!)
        
        self.heightConstraintOfBottomView.constant = self.originalHeightOfBottomView
        
        UIView.animateWithDuration(1.0, animations: {[weak self] () -> Void in
            self?.view.layoutIfNeeded()
            }) { [weak self] (finished:Bool) -> Void in
                self?.gestureView.addGestureRecognizer(self!.topPanGesture)
        }
        
    }
}
