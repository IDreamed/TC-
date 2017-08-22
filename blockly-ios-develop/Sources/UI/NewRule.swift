//
//  NewRule.swift
//  Blockly
//
//  Created by 张 on 2017/5/31.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class NewRule: UIView {

    let leftPading: CGFloat = 15;
    let rightPading: CGFloat = 40;
    var count: CGFloat = 2;
    var boxWidth: CGFloat = 0;
    var lineWidth1: CGFloat?;
    var lineWidth2: CGFloat?;
    var callBack: IntCallBack?;
    
    var storkeColor: UIColor? {
        didSet {
        
            self.setNeedsDisplay();
        }
    };
    
    var value: Int = 0 {
        didSet {
        
            if self.callBack != nil {
                
                self.callBack!(value);
            }
        }
    };
    
    let slid: UIImageView = {
        let image = UIImageView.init();
        image.image = UIImage.init(named: "yd_julidingwei");
        image.isUserInteractionEnabled = true;
        image.contentMode = .scaleAspectFit;
        
        return image;
        
    }();
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        self.coffView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView() {
        
        self.lineWidth1 = self.bounds.height / 4;
        self.lineWidth2 = self.lineWidth1!/2;
        
        let lineHeight = self.bounds.width - leftPading - rightPading;
        boxWidth = lineHeight / 10 - 2.0;
        
        self.backgroundColor = UIColor.clear;
        
        let height = self.bounds.height / 8 * 5;
        
        self.slid.frame = CGRect.init(x: 0, y: 0, width: height/40*25, height: height);
        
        self.slid.center.x = leftPading-1;
        
        self.addSubview(self.slid);
        
        self.setNeedsDisplay();
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        context!.setStrokeColor(UIColor.init(red: 0.667, green: 0.8, blue: 0.6, alpha: 1).cgColor);
        
        if self.storkeColor != nil {
            
            context!.setStrokeColor(self.storkeColor!.cgColor);
        }
        
        let letfSet = leftPading - 1.0;
        
        for i in 0 ..< 10 {
        
            var fromX = letfSet + CGFloat(i)*(2.0+boxWidth);
            var toX = fromX + 2;
            
            self.addLineWith(context: context!, lineWidth: lineWidth1!, fromeX: fromX, toX: toX);
            
            
            fromX = toX;
            toX = fromX + boxWidth;
            self.addLineWith(context: context!, lineWidth: lineWidth2!, fromeX: fromX, toX: toX);
            
            if i == 9 {
                 fromX = letfSet + CGFloat(10)*(2.0+boxWidth);
                 toX = fromX + 2;
                
                self.addLineWith(context: context!, lineWidth: lineWidth1!, fromeX: fromX, toX: toX);
            }
            
        }
        
        for i in 1 ... 10 {
            
            if i >= 1 {
                
                let fromX = letfSet + CGFloat(i)*(2.0+boxWidth) + 4;
                
                let point = CGPoint.init(x: fromX, y: self.bounds.height - lineWidth1!-4);
                
                var strig: NSString = NSString.init(format: "%d", i * 10);
                if i == 10 {
                    
                    strig = strig.appendingFormat("cm");
                }
                
                let font = UIFont.systemFont(ofSize: lineWidth1!-4);
                strig.draw(at: point, withAttributes: [NSFontAttributeName : font]);
            }
            
        }
        
        
    }
    
    func addLineWith(context:CGContext, lineWidth: CGFloat, fromeX:CGFloat, toX:CGFloat) {
        
        let Y = self.bounds.height - lineWidth/2;
        
        context.move(to: CGPoint.init(x: fromeX, y: Y));
        context.addLine(to: CGPoint.init(x: toX, y: Y));
        
        context.setLineWidth(lineWidth);
        
        context.strokePath();
        
    }
    
    //MARK: -touch相关
    var isTouch = false;
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let view = touches.first?.view;
        
        if view!.isMember(of: UIImageView.self) {
            
            isTouch = true;
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isTouch {
            
            var X = touches.first!.location(in: self).x;
            
            if X > leftPading + CGFloat(10)*(2.0+boxWidth) - 1 {
                
                X = leftPading + CGFloat(10)*(2.0+boxWidth) - 1
            }
            
            if X < leftPading + 1 {
                
                X = leftPading + 1;
            }
            
            self.slid.center.x = X;
            
            self.updataValue(X: X);
            
        }
        
    }
    
    func updataValue(X: CGFloat) {
        
        let value = X - (leftPading + 1);
        
        let allWidth = self.bounds.width - leftPading - rightPading - 2;
        
        let newValue = lrint(Double(value / allWidth * 100));
        
        self.value = newValue;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isTouch = false;
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isTouch = false;
    }
    
}
