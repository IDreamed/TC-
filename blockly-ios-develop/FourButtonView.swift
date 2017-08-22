//
//  FourButtonView.swift
//  Pods
//
//  Created by 张 on 2017/5/24.
//
//

import UIKit

class FourButtonView: UIView {

    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame);
        self.addSubViewWith(frame: frame);

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //290 * 75
    public func addSubViewWith(frame: CGRect)
    {
        
        let images = ["bl_yuan_2","bl_fang_2","bl_sanjiao_2","bl_xingxing_2"];
        
        let mainSize = CGSize(width: 290, height: 75);
        
        let buttonWidht = 60/mainSize.width * self.bounds.width;
        
        
        let speace = (self.bounds.width - 4 * buttonWidht)/7;

        let topSpeace = (self.bounds.height - buttonWidht)/2;
        
        for i in 0..<images.count {
            
            let button = UIButton.init(type: UIButtonType.custom);
            
            let name = images[i];
            
            button.setBackgroundImage(UIImage.init(named: name), for: UIControlState.normal);
            
            let X = speace*CGFloat(i+2);
            let Y = topSpeace;
            
            button.frame = CGRect(x:X, y:Y, width: buttonWidht, height: buttonWidht);
            
            button.tag = 4*100+i;
            
            button.addTarget(self, action: #selector(self.buttonClink(button:)), for: UIControlEvents.touchUpInside);
            self.addSubview(button);
            
        }
        
        
    }
    
    func buttonClink(button:UIButton) {
        
        NSLog("%d", button.tag);
    }

}
