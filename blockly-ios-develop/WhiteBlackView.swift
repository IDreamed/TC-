//
//  WhiteBlackView.swift
//  Pods
//
//  Created by 张 on 2017/5/25.
//
//

import UIKit

class WhiteBlackView: UIView {

    
    public override init(frame: CGRect) {
      
        super.init(frame: frame);
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = AlertViewControl.replaceWidth(value: 20);
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
