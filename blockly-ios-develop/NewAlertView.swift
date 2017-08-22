//
//  NewAlertView.swift
//  Pods
//
//  Created by 张 on 2017/5/24.
//
//

import UIKit


class NewAlertView: UIView {
    
    
    @IBOutlet weak var titleHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var contextHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var footHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var contextView: UIView!
    @IBOutlet weak var footView: UIView!
   
    public var titleHeight: CGFloat = 0;
    public var contextHeight: CGFloat = 0;
    public var footHeight: CGFloat = 0;
    public var ABStyle: AlertViewControl.alertBackStyle = .defaultStyle {
        
        didSet {
            self.coffSubView();
        }
    };
    
    public init(frame: CGRect, style: AlertViewControl.alertBackStyle) {
        
        self.ABStyle = style;
        
        super.init(frame: frame);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func coffSubView() {
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        
        let size = self.reSizeAlertViewWith(style: self.ABStyle);
        
        let cnetr = self.center;
        
        self.frame.size = size;
        
        self.center = cnetr;
        
        
        self.resizeSubView();
                
    }
    
    
    
}

  //MARK: - 辅助类

extension NewAlertView {
    
    //返回弹窗大小
    func reSizeAlertViewWith(style: AlertViewControl.alertBackStyle) -> CGSize {
        
        var size = CGSize.init(width: 0, height: 0);
        switch style {
        case .defaultStyle:
            // 1080 933
            
            size = AlertViewControl.resize(size: CGSize.init(width: 1080, height: 933));
            
            break;
            
        case .noFoot:
            // 1080 760
            
            size = AlertViewControl.resize(size: CGSize.init(width: 1080, height: 760));
            
            break;
            
        case .noFootShout:
            //1080 527
            
            size = AlertViewControl.resize(size: CGSize.init(width: 1080, height: 527));
            
            
            break;
            
        case .noFootLong:
            //1080 933
            
            size = AlertViewControl.resize(size: CGSize.init(width: 1080, height: 933));
            
            break;
        }
        
        return size;
        
    }

    
    //根据类型重新布局
    func resizeSubView() {
        
        switch self.ABStyle {
        case .defaultStyle:
            // 1080 933
            
            self.titleHeight = self.bounds.height / 6;
            self.contextHeight = self.bounds.height / 6 * 4;
            self.footHeight = self.bounds.height / 6;
            
            break;
            
        case .noFoot:
            // 1080 760
            
            self.titleHeight = self.bounds.height / 5;
            self.contextHeight = self.bounds.height / 5 * 4;
            self.footHeight = 0;
            
            break;
            
        case .noFootShout:
            //1080 530
            
            self.titleHeight = self.bounds.height / 4;
            self.contextHeight = self.bounds.height / 4 * 3;
            self.footHeight = 0;
            
            break;
            
        case .noFootLong:
            //1080 933
            
            self.titleHeight = self.bounds.height / 6;
            self.contextHeight = self.bounds.height / 6 * 5;
            self.footHeight = 0;
            break;
        }
        
        UIView.animate(withDuration: 0.2) { 
            
            self.titleHeightLayout.constant = self.titleHeight;
            self.contextHeightLayout.constant = self.contextHeight;
            self.footHeightLayout.constant = self.footHeight;
        }
        
        
    }

}
