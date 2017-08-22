//
//  SoundView.swift
//  Blockly
//
//  Created by zhang on 2017/6/1.
//  Copyright © 2017year Google Inc. All rights reserved.
//

import UIKit

class SoundView: UIView {
    
    let soundArray = ["do", "re", "mi", "fa", "so", "la", "si", "Do"];
    
    var callBack: StringCallBack?;
    
    var selectView: UIView = UIView.init();
    
    
    var currentSound: String = "do" {
        
        didSet {
            if callBack != nil {
                
                self.callBack!(currentSound);
            }
        }
    
    };

    public init (frame: CGRect, level:String) {
        
        super.init(frame: frame);
        
        self.coffSubView(level: level);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func coffSubView(level:String) {
        
        let images = ["yj_do","yj_re","yj_mi","yj_fa","yj_so","yj_la","yj_xi","yj_do_2"];
        
        let levels: [String] = ["do","re","mi","fa","so","la","si","Do"];
        
        let index:Int? = levels.index(of: level);

        let width = self.bounds.width / 17;
        let height = self.bounds.height / 1.2;
        
        for i in stride(from: images.count-1, through: 0, by: -1) {
            
            let x = width * CGFloat(i * 2 + 1);
            let sheight = height - CGFloat(7-i) * height/16;
            
            let imageView = UIImageView.init(frame: CGRect.init(x: x, y: self.bounds.height - sheight, width: width, height: sheight));
            
            imageView.contentMode = .scaleToFill;
            imageView.image = UIImage.init(named: images[i]);
            
            imageView.tag = 300 + i;
            imageView.isUserInteractionEnabled = true;
            self.addSubview(imageView);
            
            if i == index {
                
                self.selectView = imageView;
                imageView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2);
                let ofSetY = imageView.bounds.height * 1.2 - imageView.bounds.height;
                imageView.center.y -= ofSetY/2;
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let view = touches.first!.view;
        
        if view!.isMember(of: UIImageView.self) {
            
            if self.selectView == view {
                
                return ;
            } else {
            
                let ofSetY = view!.bounds.height * 1.2 - view!.bounds.height;
                let selectSetY = self.selectView.bounds.height - self.selectView.bounds.height / 1.2;
                
                self.selectView.transform = CGAffineTransform.init(scaleX: 1, y: 1);
                
                self.selectView.center.y += selectSetY/2;
                
                let imageTag = view!.tag - 300;
            
                let value = self.soundArray[imageTag];
            
                view!.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2);
                view!.center.y -= ofSetY/2;
                
                self.currentSound = value;
                self.selectView = view!;
            
            }
        }
        
    }
    

}
