//
//  LeLoadingAnimationView.swift
//  OneLoadingAnimationCompleteSwift
//
//  Created by 飞 刘 on 16/2/25.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

import UIKit

class LeLoadingAnimationView: UIView {

    // MARK: property
    let kName = "name"
    
    internal let kStep1Duration = 2.0
   
    internal let kStep2Duration = 1.0
    
    internal var kRadius: CGFloat = 40.0
    internal var kLineLong: CGFloat = 12.0
    let kLineWidth: CGFloat = 3.0

    
    var arcToCircleLayer: ArcToCircleLayer?

    var verticalAppearLayer: CAShapeLayer?
    var leftAppearLayer: CAShapeLayer?
    var rightAppearLayer: CAShapeLayer?
    
    var likeColor: UIColor?
    
    private var stoped = true
 
    
    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeColor = UIColor(red: 0x46/255.0, green: 0x4d/255.0, blue: 0x65/255.0, alpha: 1.0)
    }
    
    // MARK: - public
    func start() {
        stoped = false
        reset()
        doStep1()
    }
    
    func stop(){
        stoped = true
        reset();
    }
    
    
    // MARK: - reset
    func reset() {
        arcToCircleLayer?.removeFromSuperlayer()

        verticalAppearLayer?.removeFromSuperlayer()
        leftAppearLayer?.removeFromSuperlayer()
        rightAppearLayer?.removeFromSuperlayer()

        self.layer.removeAllAnimations()
    }
    
   
    
    // MARK: - step1
    func doStep1() {
        arcToCircleLayer = ArcToCircleLayer()
        arcToCircleLayer!.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth)
        arcToCircleLayer!.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        arcToCircleLayer!.contentsScale = UIScreen.mainScreen().scale
        arcToCircleLayer!.color = likeColor
        arcToCircleLayer!.lineWidth = NSNumber(double: Double(kLineWidth))
        self.layer.addSublayer(arcToCircleLayer!)
        
        // end status
        arcToCircleLayer!.progress = NSNumber(double: 1.0)
        
        // animation
        let animation = CABasicAnimation(keyPath: "progress")
        animation.duration = kStep1Duration
        animation.fromValue = NSNumber(double: 0.0)
        animation.toValue = NSNumber(double: 1.0)
        animation.delegate = self
        animation.setValue("step1", forKey: kName)
        arcToCircleLayer!.addAnimation(animation, forKey: nil)
    }
    
    // MARK: - step2
    func doStep2() {
        doStep2a()
        doStep2b()
        doStep2c()
    }
    
    // 竖线成长到全长
    func doStep2a() {
        // SS(strokeStart)
        verticalAppearLayer = CAShapeLayer()
        self.layer.addSublayer(verticalAppearLayer!)
        
        let path = UIBezierPath()
        let originPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - kRadius + kLineLong);
        path.moveToPoint(originPoint)
        
        var destPoint = originPoint;
       
        destPoint.y = CGRectGetMidY(self.bounds) - kRadius;
        path.addLineToPoint(destPoint)
        
        verticalAppearLayer!.path = path.CGPath;
        verticalAppearLayer!.lineWidth = kLineWidth;
        verticalAppearLayer!.strokeColor = likeColor!.CGColor;
        verticalAppearLayer!.fillColor = nil;
        
        // end status
        let strokeEnd: CGFloat = 1;
        verticalAppearLayer!.strokeEnd = strokeEnd;
        
        // animation
        let anima = CABasicAnimation(keyPath: "strokeEnd")
        anima.duration = kStep2Duration;
        anima.fromValue = 0;
        anima.toValue = strokeEnd
        anima.delegate = self
        anima.setValue("step2", forKey: kName)
        verticalAppearLayer!.addAnimation(anima, forKey: nil)
    }
    
    // 左下斜线成长到全长
    func doStep2b() {
        leftAppearLayer = CAShapeLayer()
        self.layer.addSublayer(leftAppearLayer!)
        
        let path = UIBezierPath()
        let originPoint = CGPointMake(CGRectGetMidX(self.bounds) - kLineWidth * 2, CGRectGetMidY(self.bounds) - kRadius + kLineLong);
        path.moveToPoint(originPoint)
        let deltaX: CGFloat = kLineLong * sin(CGFloat(M_PI) / 8);
        let deltaY: CGFloat = kLineLong * cos(CGFloat(M_PI) / 8);
        var destPoint = originPoint;
        destPoint.x -= deltaX;
        destPoint.y -= deltaY;
        path.addLineToPoint(destPoint)
        leftAppearLayer!.path = path.CGPath;
        leftAppearLayer!.lineWidth = kLineWidth;
        leftAppearLayer!.strokeColor = likeColor!.CGColor;
        leftAppearLayer!.fillColor = nil;
        
        // end status
        let strokeEnd: CGFloat = 1;
        leftAppearLayer!.strokeEnd = strokeEnd;
        
        // animation
        let anima = CABasicAnimation(keyPath: "strokeEnd")
        anima.duration = kStep2Duration;
        anima.fromValue = 0;
        anima.toValue = strokeEnd
        leftAppearLayer!.addAnimation(anima, forKey: nil)
    }
    
    // 右下斜线成长到全长
    func doStep2c() {
        rightAppearLayer = CAShapeLayer()
        self.layer.addSublayer(rightAppearLayer!)
        
        let path = UIBezierPath()
        let originPoint = CGPointMake(CGRectGetMidX(self.bounds) + kLineWidth * 2, CGRectGetMidY(self.bounds) - kRadius + kLineLong);
        path.moveToPoint(originPoint)
        let deltaX: CGFloat = kLineLong * sin(CGFloat(M_PI) / 8);
        let deltaY: CGFloat = kLineLong * cos(CGFloat(M_PI) / 8);
        var destPoint = originPoint;
        destPoint.x += deltaX;
        destPoint.y -= deltaY;
        path.addLineToPoint(destPoint)
        rightAppearLayer!.path = path.CGPath;
        rightAppearLayer!.lineWidth = kLineWidth;
        rightAppearLayer!.strokeColor = likeColor!.CGColor;
        rightAppearLayer!.fillColor = nil;
        
        // end status
        let strokeEnd: CGFloat = 1;
        
        // animation
        rightAppearLayer!.strokeEnd = strokeEnd;
        let anima = CABasicAnimation(keyPath: "strokeEnd")
        anima.duration = kStep2Duration;
        anima.fromValue = 0;
        anima.toValue = strokeEnd
        rightAppearLayer!.addAnimation(anima, forKey: nil)
    }
    
       // MARK: - animation step stop
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if(stoped){
            return
        }
        
        switch anim.valueForKey(kName) as! String {
        case "step1":
            arcToCircleLayer?.removeFromSuperlayer()
            doStep2()
        case "step2":
            reset()
            doStep1()
        
        default:
            break
        }
    }


}
