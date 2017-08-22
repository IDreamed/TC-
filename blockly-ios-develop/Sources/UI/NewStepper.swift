//
//  NewStepper.swift
//  Blockly
//
//  Created by 张 on 2017/5/31.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

typealias IntCallBack = (Int)->Void;
typealias FloatCallBack = (CGFloat)->Void;

class NewStepper: UIView {

    //bl_jiahao
    //bl_jianhao
    
    var value: Int = 0 {
        
        didSet{
            
            if self.callBack != nil {
                
                self.callBack!(value);
            }
        }
    };
    
    var max: Int = 60 {
        didSet {
            
            if value > max {
                value = max;
            }
        }
    };
    var min: Int = 0 {
        didSet {
        
            if value < min {
                
                value = min;
            }
        }
    };
    
    
    var callBack: IntCallBack?;
    
    
    let leftButton:UIButton = {
        
        let button = UIButton.init(type: UIButtonType.custom);
        
        button.setBackgroundImage(UIImage.init(named: "bl_jianhao"), for: UIControlState.normal);
        
        button.addTarget(self, action: #selector(leftClink), for: .touchUpInside);
        
        return button;
    
    }();
    
    let rightButton: UIButton = {
    
        let button = UIButton.init(type: UIButtonType.custom);
        
        button.setBackgroundImage(UIImage.init(named: "bl_jiahao"), for: UIControlState.normal);
        
        button.addTarget(self, action: #selector(rightClink), for: .touchUpInside);
        
        return button;
    
    }();
    
    let label: UILabel = {
    
        let label = UILabel();
        
        label.layer.masksToBounds = true;
        label.layer.cornerRadius = 10;
        label.textAlignment = .center;
        
        label.backgroundColor = UIColor.init(white: 1, alpha: 0.5);
        
        return label;
    }();
    
    
    
    public init(frame: CGRect, value:String) {
        
        super.init(frame: frame);
        
        self.coffSubView(value: value);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func coffSubView(value:String) {
        
        let width = self.bounds.width / 6;
        let centerY = self.bounds.height/2;
    
        
        self.leftButton.frame = CGRect.init(x: 0, y: 0, width: width, height: width);
        self.leftButton.center.y = centerY;
        
        self.addSubview(self.leftButton);
        
        var x = width + width/2;
        
        label.frame = CGRect.init(x: x, y: 0, width: width*3, height: self.bounds.height);
        label.font = UIFont.systemFont(ofSize: label.bounds.height/2);
        label.text = value
        self.value = Int(NSString.init(string: value).intValue);
        self.addSubview(label);
        
        x = x + width/2 + width*3;
        
        self.rightButton.frame = CGRect.init(x: x, y: 0, width: width, height: width);
        self.rightButton.center.y = centerY;
        
        self.addSubview(self.rightButton);
        
    }
    
    func leftClink() {
        
        var cValue: Int = Int(self.label.text!)!;
        
        cValue -= 1;
        
        if cValue < min {
            cValue = min
        }
        
        self.value = cValue;
        label.text = String.init(format: "%d", cValue);
        
    }
    
    func rightClink() {
        
        var cValue: Int = Int(self.label.text!)!;
        
        cValue += 1;
        
        if cValue > max {
            cValue = max;
        }
    
        self.value = cValue;
        label.text = String.init(format: "%d", cValue);

    }
    

}
