//
//  NewLiveView.swift
//  Blockly
//
//  Created by 张 on 2017/5/31.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit


class NewLiveView: UIView {
    
    let progressLayer: CAShapeLayer = CAShapeLayer();
    
    var progressColor: UIColor? {
        
        didSet {
            
            self.liveView?.backColor = self.progressColor;
        }
    };
    
    var levelCount: Int = 10 {
        didSet {
            
            self.liveView?.levelCount = self.levelCount;
        }
        
    };
    var liveView: liveSubView?;
    var callBack: IntCallBack?;
    var live: Int = 1 {
        
        didSet {
            
            if self.callBack != nil {
                
                self.callBack!(live);
            }
        }
    };
    
    
    public init(frame: CGRect, levelCount:Int, value:String) {
        
        super.init(frame: frame);
        
        self.coffView(value: value, levelCount:levelCount);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView(value:String, levelCount:Int) {
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
//        self.backgroundColor = UIColor.init(white: 1, alpha: 0.7);
        self.backgroundColor = UIColor.clear;
        let layerWidth = self.bounds.width - 20;
        let layerHeight = self.bounds.height - 20;
        
        self.liveView = liveSubView.init(frame: CGRect.init(x: 10, y: 0, width: layerWidth, height: layerHeight));
        
        self.liveView?.center.y = self.bounds.height/2;
        
        
        self.progressLayer.frame = self.liveView!.frame;
        
        self.layer.addSublayer(self.progressLayer);
        self.addSubview(self.liveView!);
        
        
        self.progressLayer.strokeColor = UIColor.lightGray.cgColor;
        self.progressLayer.lineWidth = layerHeight;
        
        let path = UIBezierPath.init();
        path.move(to: CGPoint(x:0, y: layerHeight/2));
        path.addLine(to: CGPoint.init(x: layerWidth, y: layerHeight/2));
        
        self.progressLayer.path = path.cgPath;
        
        self.levelCount = levelCount;
        self.live = Int(value)!;
        let pro = Float(value);
        
        self.progressLayer.strokeEnd = CGFloat(pro!/Float(self.levelCount));
    }
    
    //MARK: - touch的相关处理
    var isTouch = false;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first;
        
        let point = touch!.location(in: self);
        
        let view = touch?.view;
        
        if self.liveView!.frame.contains(point) {
            
            isTouch = true;
            self.changeLive(point: point);
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isTouch {
            
            let point = touches.first!.location(in: self);
            
            self.changeLive(point: point);
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isTouch = false;
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false;
    }
    
    func changeLive(point: CGPoint) {
        
        let x = point.x - 10;
        
        let boxWidth = self.liveView!.bounds.width/CGFloat(self.levelCount);
        
        var index = Int(ceil(x/boxWidth));
        
        if index < 1 {
            index = 1;
        }
        if index > self.levelCount {
            
            index = self.levelCount;
        }
        
        
        self.progressLayer.strokeEnd = CGFloat(index)/CGFloat(self.levelCount);
        
        self.live = index;
        
        NSLog("%d", self.live);
        
    }
    
}

//MARK: - 画 十个级别的 view
class liveSubView: UIView {
    
    var levelCount = 10 {
        
        didSet {
            
            self.setNeedsDisplay();
        }
    };
    
    var backColor: UIColor? {
        didSet {
            self.setNeedsDisplay();
        }
    };
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        
        self.setNeedsDisplay();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        
        var color1 = UIColor.init(red: 254/255.0, green: 81/255.0, blue: 117/255.0, alpha: 0.6).cgColor;
        if self.backColor != nil {
            color1 = self.backColor!.withAlphaComponent(0.8).cgColor;
        }
        let color2 = UIColor.init(red: 217/255.0, green: 82/255.0, blue: 126/255.0, alpha: 1).cgColor;
        
        
        let lineWidth = self.bounds.height;
        
        context?.setLineWidth(lineWidth);
        
        let boxWidth = (self.bounds.width)/CGFloat(self.levelCount);
        
        for i in 0 ..< self.levelCount {
            
            var fromX = (CGFloat(i) * boxWidth + 1);
            var toX = fromX+boxWidth;
            
            self.addlineWith(context: context!, color: color1, fromX: fromX, toX: toX);
            
            fromX = CGFloat(i) * boxWidth;
            toX = fromX + 1;
            
            self.addlineWith(context: context!, color: color2, fromX: fromX, toX: toX);
        }
        
        
        
    }
    
    func addlineWith(context:CGContext, color: CGColor, fromX: CGFloat, toX: CGFloat) {
        
        context.setStrokeColor(color);
        
        let Y = self.bounds.height/2;
        context.move(to: CGPoint.init(x: fromX, y: Y));
        context.addLine(to: CGPoint.init(x: toX, y: Y));
        context.strokePath();
        
    }
}
