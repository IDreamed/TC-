//
//  NewSwitch.swift
//  Blockly
//
//  Created by 张 on 2017/5/26.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

@objc(NewSwitch)
class NewSwitch: UIView {

    // 208/84 图片大小比例
    var isOn: Bool = false {
        
        didSet {
            
            if self.isOn {
                
                self.slid.frame.origin.x += (self.offImageView.bounds.width - self.slid.bounds.width);
                self.onImageView.frame.size.width = self.offImageView.bounds.width;
            } else {
                
                self.slid.frame.origin.x = self.offImageView.frame.origin.x;
                self.onImageView.frame.size.width = 0;
                
            }
            if self.callback != nil {
                
                let i: Int = self.isOn ? 1 : 0;
                
                self.callback!(i);
            }
        }
    };
    
    var callback: IntCallBack?;
    var currentTitle: String? {
        didSet {
            
            isOn = currentTitle! == onTitle;
        }
    }
    
    var offTitle = "or";
    var onTitle = "and";
    
    
    var onImage: String = "gj_anniubeijing_lv" {
    
        didSet {
            
            self.onImageView.image = UIImage.init(named: onImage);
            
        }
    };
    
    var offImage: String = "gj_anniubeijing_hong" {
    
        didSet {
            self.offImageView.image = UIImage.init(named: offImage);
        }
    };
    
    private let onImageView: UIImageView = {
        
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFit;
//        imageView.backgroundColor = UIColor.green;
        return imageView;
    
    }();
    
    private let offImageView: UIImageView = {
        
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFit;
//        imageView.backgroundColor = UIColor.white;

        return imageView;
        
    }();
    
    private let slid: UIImageView = {
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFit;
        imageView.image = UIImage.init(named: "yd_suduhuakuai");
        return imageView
    }();
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.coffSubView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffSubView() {
        
        self.isUserInteractionEnabled = true;
        self.backgroundColor = UIColor.clear;
        
        let hieght: CGFloat  = self.bounds.width / 208 * 84;
        
        offImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: hieght);
        
        offImageView.image = UIImage.init(named: offImage);
        
        let center = CGPoint.init(x: self.bounds.size.width/2,
                                 y: self.bounds.size.height/2);
        
        offImageView.center = center;
        
        offImageView.layer.masksToBounds = true;
        offImageView.layer.cornerRadius = hieght/2;
        
        self.addSubview(offImageView);
        
        onImageView.frame = CGRect.init(x: offImageView.frame.origin.x, y: offImageView.frame.origin.y, width: 0, height: hieght);
        
        onImageView.image = UIImage.init(named: onImage);
        
        
        onImageView.layer.masksToBounds = true;
        onImageView.layer.cornerRadius = hieght/2;
        
        self.addSubview(onImageView);
        
        
        slid.frame = CGRect.init(x: offImageView.frame.origin.x, y: offImageView.frame.origin.y, width: hieght, height: hieght);
        
        self.addSubview(slid);
        
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        return self;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        UIView.animate(withDuration: 0.2) { 
            
            self.isOn = !self.isOn;
            
            
        }
        
    }
    
    
    
}
