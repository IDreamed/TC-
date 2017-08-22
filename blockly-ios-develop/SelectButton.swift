//
//  SelectButton.swift
//  Pods
//
//  Created by 张 on 2017/5/25.
//
//

import UIKit


class SelectButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public init(frame: CGRect, image: UIImage, borderColor: UIColor) {
        
        super.init(frame: frame);
        
        self.setCoff(image: image, borderColor: borderColor);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        
        willSet {
        
        }
        
        didSet{
        
            self.layer.borderColor = isSelected ?self.borderColor.cgColor:UIColor.clear.cgColor;
            self.layer.borderWidth = 1;
            
        }
    }
    
    var borderColor = UIColor.red;
    
    func setCoff(image: UIImage, borderColor:UIColor) {
        
        
        
        self.backgroundColor = UIColor.clear;
        self.setImage(image, for: UIControlState.normal);
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        
        self.borderColor = borderColor;
        
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event);
        
       
        return hitView == self ?nil:hitView;
        
    }
    
}
    
