//
//  ClockView.swift
//  Blockly
//
//  Created by 张 on 2017/5/26.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

//yd_fangxiangzhen
//yd_fangxiangquan


class ClockView: UIView {
    
    var clockCallBack: IntCallBack?;
    
    //TODO : - 放大镜没做
//    var masView: MaskView?;

    var clockBack: UIImageView = {
    
        let imageView = UIImageView.init(image: UIImage.init(named: "yd_fangxiangquan"));
        
        
        return imageView;
    
    }();
    
    //表针的旋转半径
    var line: CGFloat = 0;
    
    //TODO: - 双倍高度 中心旋转
    var clockRotationView: ClockSubView?;
    
    
    override init(frame: CGRect) {
       
    
        super.init(frame: frame);
        
        self.coffSubView();

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffSubView() {
        
        let clockWidth = self.bounds.width - 40;
        
        let center = CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2);
        
        self.clockBack.frame = CGRect.init(x: 0, y: 0, width: clockWidth, height: clockWidth);
        self.clockBack.center = center;
        
        self.addSubview(self.clockBack);
        
        self.clockRotationView = ClockSubView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: clockWidth/2 + 10));
        
        self.line = self.clockRotationView!.center.y - self.clockRotationView!.topView.center.y;
        
        let centerY = center.y;
        
        self.clockRotationView!.center = CGPoint.init(x: center.x, y: centerY);
        
        self.addSubview(clockRotationView!);
        
//        self.masView = MaskView.init(frame: CGRect(x:0, y:0, width:22, height:22));
//        
//        self.masView?.center = CGPoint(x: self.clockRotationView!.topView.bounds.width/2-1,
//                                       y: self.clockRotationView!.topView.bounds.height/2+1);
//        
//        self.masView?.scaleView = self.clockBack;
//        
//        self.masView?.timerDisPlay(point: self.returnMaskViewCenter());
//        self.clockRotationView!.topView.addSubview(self.masView!);
        
        
    }
    
    //确定透明放大镜的中心点
    
    func returnMaskViewCenter() -> CGPoint {
        
        let angle = self.currentAngle;
        
        let sinx = sin(angle);
        let cosx = cos(angle);
        
        let line = self.line;
        
        var x = sinx * line + self.center.x;
        
        var y = cosx * line + self.center.y;
        
        
        NSLog("X :%f  Y :%f ", x, y);
        
        return CGPoint(x: x, y: y);
        
    }
   
    //MARK: - 手势交互
    var isTouch = false;
    
    var currentAngle: CGFloat = 0.0 {
        didSet {
        
            if self.clockCallBack != nil {
                
                let angle: NSInteger = Int(self.currentAngle / .pi * 180);
                
                self.clockCallBack!(angle);
            }
            
        }
    };
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first;
        
        let touchPoint = touch?.location(in: self);
        
        let view = touch?.view;
        
        if view == nil {
            
            return ;
        }
        
        if view!.isMember(of: UIImageView.self) {
            
            self.isTouch = true;
            
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isTouch {
            
            let movePoint = touches.first!.location(in: self);
            let center = CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2);
            
            let angle = self.returnAngle(center: center, touchPoint: movePoint);
            
            self.clockRotationView!.transform = CGAffineTransform.init(rotationAngle: angle);
            
//            self.masView?.timerDisPlay(point: self.returnMaskViewCenter());
            self.currentAngle = angle;

            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isTouch = false;
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isTouch = false;
        
    }
    
    //计算角度
    
    func returnAngle(center: CGPoint, touchPoint: CGPoint) -> CGFloat {
        
        let point = CGPoint(x: touchPoint.x-center.x, y: touchPoint.y-center.y);
        
        
        var angle = atan2(point.x, point.y);
        
        
        if angle>=0 {
            
            angle = .pi - angle;
            
        } else {
            
            angle = .pi - angle;
        }
     
        return angle;
    }
    
}



class ClockSubView: UIView {
    
    
    var topView: UIImageView = {
        
        let image = UIImageView.init(image: UIImage.init(named: "clockTop"));
        
        let size = AlertViewControl.resize(size: CGSize.init(width: 60, height: 60));
        image.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height);
        image.contentMode = .scaleAspectFit;
        image.isUserInteractionEnabled = true;
        
        return image;
    
    }();
    
    var bodyView: UIImageView = {
        
        let image = UIImageView.init(image: UIImage.init(named: "clockBody"));
        image.contentMode = .scaleAspectFit;
        
        return image;
    }();
    
    var footView: UIImageView = {
    
        let image = UIImageView.init(image: UIImage.init(named: "clockFoot"));
        
        let size = AlertViewControl.resize(size: CGSize.init(width: 20, height: 20));
        
        image.frame = CGRect(x: 0, y:0, width: size.width, height: size.height);
        image.contentMode = .scaleAspectFit;

        
        return image;
    }();
    
     override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.cofSubView(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cofSubView(frame: CGRect) {
        
        
        let bounds = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height);
        
        let centerX = bounds.width/2;
        
        
        topView.center = CGPoint.init(x: centerX, y: topView.center.y);
        
        self.addSubview(topView);
        
        footView.center = CGPoint.init(x: centerX, y: bounds.height - footView.bounds.height/2);
        
        self.addSubview(footView);
        
        let bodyHeight = bounds.height - topView.bounds.height - footView.bounds.height;
        
        bodyView.frame = CGRect.init(x: 0, y: topView.bounds.height, width: 7, height: bodyHeight);
        
        bodyView.center = CGPoint.init(x: centerX, y: bodyView.center.y);
        
        self.addSubview(bodyView);
        
        let newHeight = self.bounds.height - self.footView.bounds.height/2;
        
        self.frame.size.height = newHeight + self.bounds.height;
        
//        NSLog("%f    %f",self.bounds.width/2, self.bounds.height/2);

        
    }
    
}

class MaskView: UIView {
    
    weak var scaleView: UIView?;
    
    var touchPoint = CGPoint(x:0, y:0);
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        self.coffView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func coffView() {
        
        self.layer.masksToBounds = true;
        
        self.layer.cornerRadius = self.bounds.height / 2;
        
        self.backgroundColor =  UIColor.clear;
        
        
    }
    
    func timerDisPlay(point: CGPoint) {
        
//        NSLog("disPlay");
        
        self.touchPoint = point;
//        self.center = point;
        self.setNeedsDisplay();
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event);
        
        return view==self ? nil : view;
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        
        context!.translateBy(x: self.bounds.width/2, y: self.bounds.height/2);
        
        context!.scaleBy(x: 1.5, y: 1.5);
        
        context!.translateBy(x: -1*touchPoint.x, y: -1*touchPoint.y);
        
        if self.scaleView != nil {
            
            self.scaleView?.layer.render(in: context!);
            
        }
        
        
    }
}

