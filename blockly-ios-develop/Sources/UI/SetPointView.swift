//
//  SetPointView.swift
//  Blockly
//
//  Created by 张 on 2017/7/24.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class SetPointView: UIView {

    let pading: CGFloat = AlertViewControl.replaceWidth(value: 20);
    var callBack:StringCallBack?;
    var currentTitle: UIButton?;
    
    public init(frame: CGRect, type: String, value: String) {
        
        super.init(frame: frame);
        
        let path = Bundle.main.path(forResource: "type_point", ofType: "plist");
        let dic = NSDictionary.init(contentsOfFile: path!);
        let datas: [String] = dic!.value(forKey: type) as! [String];
        
        self.createSubView(datas: datas, value: value);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public init(frame: CGRect, datas:[String], value: String) {
        
        super.init(frame: frame);
        
        self.createSubView(datas: datas, value: value);
    }
    
    func createSubView(datas:[String], value: String) {
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = AlertViewControl.replaceWidth(value: 20);

        let width = AlertViewControl.replaceWidth(value: 200);
        let height = width/2;
        
        let speace: CGFloat = (self.frame.width - width * CGFloat(datas.count)) / CGFloat(datas.count + 1);
        
        for i in 0 ..< datas.count {
            
            let text = datas[i];
            let button = UIButton.init(type: .custom);
            button.frame = CGRect.init(x: speace + CGFloat(i)*(width + speace), y: 0, width: width, height: height);
            button.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
            button.center.y = self.bounds.height/2;
            button.setTitle(text, for: .normal);
            button.addTarget(self, action: #selector(touchClink(sender:)), for: .touchUpInside);
            button.layer.borderColor = UIColor.orange.cgColor;
            button.backgroundColor =  UIColor.init(red: 0.482, green: 0.745, blue: 0.973, alpha: 1);
            button.layer.masksToBounds = true;
            button.layer.cornerRadius = 10;
            self.addSubview(button);
            
            if text == value {
                button.layer.borderWidth = 2;
                self.currentTitle = button;
                
            }
            
        }
    }
    
    func createSubView(value:String) {
        
        
        
    }
    
    func touchClink(sender: UIButton) {
        
        if self.currentTitle != nil {
            self.currentTitle!.layer.borderWidth = 0;

        }
        sender.layer.borderWidth = 2;
        self.currentTitle = sender;
        let title = sender.titleLabel!.text!;
        NSLog("%@",sender.titleLabel!.text!);
        
        if callBack != nil {
            callBack!(title);
        }
    }

}
