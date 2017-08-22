//
//  CheckBackView.swift
//  Blockly
//
//  Created by 张 on 2017/6/25.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class CheckBackView: UIView {
    
    public var heads:[String]? {
        didSet {
        
            self.createSubView();

        }
        
    };

    public var views: [UIView] = Array();
    
    public var titeViews: [UIView] = Array();
    
    public var callback: StringCallBack?;
    
    @IBOutlet weak var shuzi: UIView!
    @IBOutlet weak var shuziWidth: NSLayoutConstraint!
    
    @IBOutlet weak var bianliang: UIView!
    
    @IBOutlet weak var bianliangWidth: NSLayoutConstraint!
    
    @IBOutlet weak var chuangan: UIView!
    
    @IBOutlet weak var chuanganWidth: NSLayoutConstraint!
    
    @IBOutlet weak var suiji: UIView!
    @IBOutlet weak var suijiWidth: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    
    public var currentView: UIView?;
    
    public var num1: Int = 1;
    public var num2: Int = 1;
    
//    public init(frame: CGRect, heads: [String]) {
//        
//    
//        self.heads = heads;
//        super.init(frame: frame);
//        
//        self.createSubView();
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {

        super.awakeFromNib();
        

    }
    
    func createSubView() {
        
        self.titeViews = [shuzi,bianliang,chuangan,suiji];

        self.backView.setNeedsLayout();
        self.backView.layoutIfNeeded();
        self.backgroundColor = UIColor.init(red: 0.4, green: 0.443, blue: 0.859, alpha: 1);
        
        let width = self.bounds.width / CGFloat(heads!.count);
        
        for i in 0 ..< heads!.count {
            
            let title = heads![i];
            let titles = ["shuzi","bianliang","chuangan","suiji"];
            
            let index: Int = titles.index(of: title)!;
            
            switch index {
            case 0:
                self.shuziWidth.constant = width;
                
                let view = NumberKeyBord.init(frame: self.backView.bounds);
                view.callBack = {
                    [weak self](str: String) in
                    if self!.callback != nil {
                        self!.callback!(str);
                    }
                }
                views.append(view);
                
                break;
            case 1:
                
                self.bianliangWidth.constant = width;
                let bundel = Bundle(identifier: "com.google.blockly.Blockly");
                let view = bundel!.loadNibNamed("FourValueView", owner: self, options: nil)?.last as! FourValueView;
                view.frame = self.backView.bounds;
                view.callbcak = {
                    [weak self](str: String) in
                    if self!.callback != nil {
                        self!.callback!(str);
                    }
                };
                
                views.append(view);
                
                break;
            case 2:
                self.chuanganWidth.constant = width;
                let view = self.createTableView(frame: self.backView.bounds, names: ["超声波传感器距离","体感倾斜角度","声音传感器分贝","光敏传感器亮度","压力传感器压力","电位机数值","滑动变阻器数值"], cellHeight: AlertViewControl.replaceWidth(value: 80));
                view.backgroundColor = UIColor.clear;
                view.callBack = {
                    [weak self](model: RectModel) in
                    if self!.callback != nil {
                        self!.callback!(model.name);
                    }
                };
                views.append(view);
                break;
            case 3:
                self.suijiWidth.constant = width;
                let view = self.createRandomView();
                views.append(view);
                break;
            default:
            
                break
            }
            
            
        }
        self.currentView = self.shuzi;
        self.setSelectView(view: self.currentView!, isSelect: true);
        
    }

    func createTableView(frame: CGRect, names: [String], cellHeight: CGFloat) -> NewTable {
        
        let table = NewTable.init(frame: frame, rowHeight: cellHeight);
        
        var models: [RectModel] = Array();
        for name in names {
            
            let model = RectModel.init();
            model.name = name;
            models.append(model);
        }
        table.dataSourcr = models;
        
        return table;
    }
    
    func createRandomView() -> UIView {
        
        let view = UIView.init(frame: self.backView.bounds);
        view.backgroundColor = UIColor.clear;
        
        let width = self.backView.bounds.width * 0.8;
        let height = self.backView.bounds.height / 8;
        let leftPading = width * 0.1;
        
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height));
        label.font = UIFont.systemFont(ofSize: 16);
        label.textColor = UIColor.init(white: 1, alpha: 0.4);
        label.text = "在下面的范围内随机选择";
        label.textAlignment = .center;
        view.addSubview(label);
        
        let steep = NewStepper.init(frame: CGRect.init(x: leftPading, y: height*2, width: width, height: height*2), value:"1");
        steep.max = 1000000;
        steep.min = 1;
        steep.callBack = {
            [weak self](value: Int) in
            self?.num1 = value;
            self?.updateRandom();
        }
        view.addSubview(steep);
        
        
        let steep1 = NewStepper.init(frame: CGRect.init(x: leftPading, y: height * 5, width: width, height: height*2), value:"1");
        steep1.max = 100000;
        steep1.min = 1;
        steep1.callBack = {
            [weak self](value: Int) in
            self?.num2 = value;
            self?.updateRandom();
        }
        view.addSubview(steep1);
        return view;
    }
    
    func updateRandom() {
        
        var value = 0;
        if self.num2 == num1 {
            
            value = num1;
        }
        
        if self.num1 > self.num2 {
            
            let coun = self.num1 - self.num2 + 1;
            value = self.num2 + Int(arc4random()) % coun;
            
        } else  if self.num2 > self.num1 {
            let coun = self.num2 - self.num1 + 1;
            value = self.num1 + Int(arc4random()) % coun;

        }
        
        let str = String.init(format: "%d", value);
        
        if self.callback != nil {
            
            self.callback!(str);
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first!.location(in: self);
        
        for view in titeViews {
            
            if (view.frame.contains(point)) {
                
                self.setSelectView(view: self.currentView!, isSelect: false);
                self.currentView = view;
                self.setSelectView(view: view, isSelect: true);
            }
        }
        
    }
    
    func setSelectView(view:UIView, isSelect:Bool) {
        
        let sviews = view.subviews;
        
        for view in sviews {
            
            if view.isMember(of: UIView.self) {
                
                view.isHidden = isSelect;
            }
            
        }
        
        let index: Int = self.titeViews.index(of: view)!;
        
        if index != Int.max {
            
            for view in self.backView.subviews {
                view.removeFromSuperview();
            }
            
            let view = self.views[index];
            
            self.backView.addSubview(view);
        }
        
    }
    
}
