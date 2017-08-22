//
//  NewSlider.swift
//  Blockly
//
//  Created by 张 on 2017/5/26.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit


class NewSlider: UIView {

    //yd_sudubaifenbi 刻度图片
    //
    
    let slider = UIImageView();
    var currentValueView: UIImageView?;
    var minColor: UIColor = UIColor.blue;
    var maxColor: UIColor = UIColor.init(white: 0.3, alpha: 1);
    var isSlid: Bool = false;
    var callBack: IntCallBack?;
    var floatCallback: FloatCallBack?;
    
    
    var value: CGFloat = 0 {
        didSet {
            
            if callBack != nil {
                
                self.callBack!(Int(self.value));
            }
            
            if floatCallback != nil {
                
                self.floatCallback!(self.value);
            }
        }
    };
    
    var hasGraduation = false;
    
    
    
    var progressLayer: CAShapeLayer = CAShapeLayer();
    
    let letPanding: CGFloat = AlertViewControl.resize(size: CGSize.init(width: 100, height: 100)).width;
    let toPanding: CGFloat = 5;
    
    let progressWidth: CGFloat?;
    
    var progressLayerSize: CGSize = CGSize.init(width: 0, height: 0);
    let imageSize = AlertViewControl.resize(size: CGSize.init(width: 65, height: 50));
    
    public init(frame: CGRect, hasGraduation: Bool, value:String) {
        
        self.progressWidth = frame.size.width - letPanding * 2;
        self.progressLayerSize = CGSize.init(width: self.progressWidth!, height: self.progressWidth! / 740 * 60);
        let selfWidth = letPanding*2 + progressLayerSize.width;
        let selfHeight = toPanding*2 + progressLayerSize.height + imageSize.height;
        
        super.init(frame: CGRect.init(x: frame.origin.x, y: frame.origin.y, width: selfWidth, height: selfHeight));
        
        self.coffSubView(hasGraduation: hasGraduation, value: value);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //930 120
    func coffSubView(hasGraduation: Bool, value:String) {
        
        self.hasGraduation = hasGraduation;
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        
        var sliderImage = "";
        if hasGraduation {
            
            
            sliderImage = "yd_suduhuakuai"
            for i in 0 ..< 5 {
                
                let imageView = UIImageView.init(image: UIImage.init(named: "yd_sudubaifenbi"));
                imageView.contentMode = .scaleAspectFit;
                
                imageView.frame = CGRect.init(x: 0, y: toPanding, width: imageSize.width, height: imageSize.height);
                let ivalue = i*20+20;
                let imageCenterX = letPanding + progressLayerSize.width/100 * CGFloat(ivalue);
                
                
                imageView.center = CGPoint.init(x: imageCenterX, y: imageView.center.y);
                
                let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height*0.75));
                label.text = String.init(format: "%d%%", ivalue);
                label.textAlignment = .center;
                label.font = UIFont.systemFont(ofSize: label.bounds.height*0.35);
                
                imageView.addSubview(label);
                
                self.addSubview(imageView);
            }
            
        } else {
            sliderImage = "slider";
            
            self.currentValueView = UIImageView.init(image: UIImage.init(named: "yd_sudubaifenbi"));
            self.currentValueView!.contentMode = .scaleAspectFit;
            
            self.currentValueView!.frame = CGRect.init(x: 0, y: toPanding, width: imageSize.width, height: imageSize.height);
            
            self.currentValueView!.center = CGPoint.init(x: letPanding, y: self.currentValueView!.center.y);
            
            let label = UILabel.init(frame: CGRect.init(x: 0,
                                                        y: 0,
                                                        width: self.currentValueView!.bounds.width,
                                                        height: self.currentValueView!.bounds.height*0.75));
            label.text = String.init(format: "%d%%", 0);
            label.textAlignment = .center;
            label.font = UIFont.systemFont(ofSize: label.bounds.height*0.35);
            
            self.currentValueView!.addSubview(label);
            
            self.addSubview(self.currentValueView!);
            
        }
        
        self.progressLayer = CAShapeLayer.init();
        self.progressLayer.frame = CGRect.init(x: letPanding,
                                               y: imageSize.height + toPanding,
                                               width: progressLayerSize.width, height: progressLayerSize.height);
        self.creatLayer();
        self.creatSlider(image: sliderImage);
        
        let index = NSString.init(string: value).integerValue;
       
        
        let pro: CGFloat =  CGFloat(index) / 100;
        
        self.updataValue(value: pro);
        let x = pro * self.progressLayer.bounds.width + self.progressLayer.frame.origin.x;
        
        self.slider.center.x = x;
        if self.currentValueView != nil {
            
            self.currentValueView!.center.x = x;
        }
        
    }
    
    func creatSlider(image: String) {
        
        self.slider.frame = CGRect.init(x: 0, y: 0, width: self.progressLayerSize.height, height: self.progressLayerSize.height);
        
        self.slider.image = UIImage.init(named: image);
        self.slider.contentMode = .scaleAspectFit;
        
        let centerY = progressLayer.frame.origin.y + progressLayer.bounds.height/2;
        
        slider.center = CGPoint.init(x: letPanding, y: centerY);
        
        self.addSubview(self.slider);
        
    }
    
    func creatLayer() {
        
        let backLayer = CAShapeLayer.init();
        backLayer.frame = self.progressLayer.frame;
        
        
        backLayer.strokeColor = self.maxColor.cgColor;
        backLayer.lineWidth = self.progressLayerSize.height-20;
        backLayer.lineWidth = self.progressLayerSize.height-15;

        backLayer.lineCap = kCALineCapRound;
        
        let backPath = UIBezierPath.init();
        backPath.move(to: CGPoint.init(x: 0, y: self.progressLayerSize.height/2));
        backPath.addLine(to: CGPoint.init(x: self.progressLayerSize.width, y: self.progressLayerSize.height/2));
        
        backLayer.path = backPath.cgPath;
        self.layer.addSublayer(backLayer);
        
        self.progressLayer.path = backPath.cgPath;
        
        self.progressLayer.lineWidth = self.progressLayerSize.height-15;
        self.progressLayer.lineCap = kCALineCapRound;
        self.progressLayer.strokeColor = self.minColor.cgColor;
        
        let slidPath = UIBezierPath.init(cgPath: backPath.cgPath);

        
        self.progressLayer.path = slidPath.cgPath;
        
        self.progressLayer.strokeEnd = 0;
        self.progressLayer.speed = 3;
        
        self.layer.addSublayer(self.progressLayer);

    }
    
    
    var touchPointX: CGFloat = 0;
    var hasX: CGFloat = 0;
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPointX = self.letPanding;
        let touch = touches.first;
        
        var touchPoint = touch!.location(in: self);
        
        if progressLayer.frame.contains(touchPoint) {
            self.touchPointX = touchPoint.x;

            isSlid = true;
            
            if self.hasGraduation {
                self.hasX = self.touchPointX;
                let line = touchPoint.x - letPanding;
                
                
                let count = Int(line/progressLayerSize.width / 0.2 + 0.5);
                var newCount: CGFloat = 0;
                
                
                newCount = CGFloat(count) * 0.2;
                
                
                NSLog("%f", newCount);
                let X = newCount * progressLayerSize.width + letPanding;
                touchPoint.x = X;
                
            }
            
            self.slider.center.x = touchPoint.x;
            if self.currentValueView != nil {
                self.currentValueView!.center.x = touchPoint.x;
            }
            
            self.updataValue(value: (touchPoint.x-letPanding)/progressLayerSize.width);
            
            return ;
        }
        
        if self.slider.frame.contains(touchPoint) {
            
            self.touchPointX = touchPoint.x;
            self.hasX = self.touchPointX;
            isSlid = true;
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first;
        let touchPoint = touch?.location(in: self);
        
        self.updateUI(pointX: touchPoint!.x);
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchPointX = letPanding;
        isSlid = false;
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchPointX = letPanding;
        isSlid = false;
    }
    
    //根据坐标点更新slid和currentimage的坐标
    
    func updateUI(pointX: CGFloat) {
        
        let xInset = pointX - self.touchPointX;
        self.touchPointX = pointX;
        
        if isSlid {
            
            
            
            var centerX = pointX;
            
            if centerX >= letPanding + progressLayerSize.width {
                
                centerX = letPanding + progressLayerSize.width;
            }
            if centerX <= letPanding {
                
                centerX = letPanding;
            }
            self.hasX = centerX;
            if self.hasGraduation {
                
                let line = centerX - letPanding;
                
                let count = Int(line/progressLayerSize.width / 0.2 + 0.5);
                var newCount: CGFloat = 0;
                
                        
                newCount = CGFloat(count) * 0.2;
                
               
                NSLog("%f", newCount);
                let X = newCount * progressLayerSize.width + letPanding;
                centerX = X;
                
                
            }
            
            self.slider.center.x = centerX;
            
            if self.currentValueView != nil {
                self.currentValueView?.center.x = centerX;
            }
            
            let value = (self.slider.center.x - letPanding) / progressLayerSize.width;
            
            self.updataValue(value: value);
            
        }

    }
    
    
    //根据slider的value更新相关设置
    func updataValue(value: CGFloat) {
        
        let intValue = value * 100;
        
        progressLayer.strokeEnd = value;
        
        self.value = intValue;
        
        if self.currentValueView != nil {
            
            let label = self.currentValueView?.subviews.first as! UILabel;
            
            label.text = String.init(format: "%d%%", Int(self.value));
            
        }
        
    }
    
}
