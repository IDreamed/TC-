//
//  DatePickerView.swift
//  Blockly
//
//  Created by 张 on 2017/5/30.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit


//200 160
class DatePickerView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var dataArray: [String]? {
    
        didSet {
        
            self.reloadData();
            
            if let index = self.dataArray!.index(of: initValue!) {
                
                let newIndex = index;
                let y = CGFloat(newIndex) * self.bounds.height/3;
                
                self.contentOffset = CGPoint.init(x: 0, y: y);
                initValue = nil;
            }
        }
    };
    let identifier = "dateCell";
    
    var callback: StringCallBack?;
    
    var initValue: String?;
    
    var currentValue: String = "" {
    
        didSet {
        
            if callback != nil {
                
                self.callback!(currentValue);
            }
        }
    };
    
    
    public init(frame: CGRect,value:String) {
        
        
        super.init(frame: frame, style: .grouped)
        
        self.initValue = value;
        
        self.coffView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView() {
        
        self.dataArray = Array.init();
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = .none;
        self.backgroundColor = UIColor.clear;
        
        self.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: self.identifier);
        self.bounces = false;
        self.showsVerticalScrollIndicator = false;
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/3));
        self.tableHeaderView = view;
//        self.backgroundView = WhiteBlackView.init(frame: self.bounds);
        
        self.reloadData();
        
        
    }
    //MARK: - cell重布局
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        let cells = self.visibleCells;
        
        
        for cell in cells {
            
            self.reSize(cell: cell);
            
        }
        
    }
    
    func reSize(cell: UITableViewCell) {
        
        
        let cellCenterY = cell.center.y;
        
        let ofSetY = self.contentOffset.y;
        let tableCenterY = self.bounds.height/2;
        
        var setY =  cellCenterY - ofSetY;
        
        setY = fabs(setY - tableCenterY);
        
        if setY > 20 {
            
            UIView.animate(withDuration: 0.1, animations: { 
                
                let scale = (setY-20) / (self.bounds.height/3 * 2);
                
                cell.textLabel!.alpha = 1-scale;
                cell.textLabel!.transform = CGAffineTransform.init(scaleX: 1, y: 1-scale);

                
            })
            
            
        } else {
            
            UIView.animate(withDuration: 0.1, animations: { 
                
                cell.textLabel!.alpha = 1;
                cell.textLabel!.transform = CGAffineTransform.init(scaleX: 1, y: 1);
            })

            
        }
        
        
    }
    
    //MARK: - tableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self
            .identifier, for: indexPath);
        
        cell.textLabel?.text = self.dataArray![indexPath.row];
        cell.backgroundColor = UIColor.clear;
        cell.selectionStyle = .none;
        cell.textLabel?.textAlignment = .center;
//        cell.textLabel?.font = UIFont.systemFont(ofSize: tableView.bounds.height/3);
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: tableView.bounds.height/3);
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.bounds.height/3;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let y = self.bounds.height/2 + self.contentOffset.y;
        
        let height = self.bounds.height/3;
        
        var index = (Int)(floor(y/height));
        
        if index >= self.dataArray!.count {
            index = self.dataArray!.count;
        }
        if index <= 1 {
            index = 1;
        }

        let Y = CGFloat(index - 1) * height;
        
        
        self.currentValue = self.dataArray![index-1];

        
        self.contentOffset = CGPoint(x: 0, y: Y);
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            let y = self.bounds.height/2 + self.contentOffset.y;
            
            let height = self.bounds.height/3;
            
            var index = (Int)(floor(y/height));
            
            if index >= self.dataArray!.count {
                index = self.dataArray!.count;
            }

            if index <= 1 {
                index = 1;
            }
            
            let Y = CGFloat(index - 1) * height;
            
            self.currentValue = self.dataArray![index-1];
            
            
            self.contentOffset = CGPoint(x: 0, y: Y);
        }
    }
    
}

public enum TimeStyle {
    
    case defaultStyle,
    centisecond
}


class DataPickerControl: UIView {
    
//    var MFomat: String;
//    var SFomat: String;
    
    var MStyle: TimeStyle = .defaultStyle {
    
        didSet {
        
            let array = self.creteDataWith(style: MStyle);
            
            self.MDateView.dataArray = array;
        }
    };
    var SStyle: TimeStyle = .defaultStyle{
        
        didSet {
            
            let array = self.creteDataWith(style: SStyle);
            
            self.SDateView.dataArray = array;
        }
    };
    
    var MData: [String] = Array();
    var SData: [String] = Array();
    var callBack: StringCallBack?;
    var MDateView: DatePickerView;
    var SDateView: DatePickerView;
    
    var MValue: String = "0" {
        didSet {
        
            let str = MValue.appending(SValue);
            
            if self.callBack != nil {
                self.callBack!(str);
            }
        }
    };
    var SValue: String = ".00" {
        didSet {
            let str = MValue.appending(SValue);
            if self.callBack != nil {
                self.callBack!(str);
            }
        }
    };
    
    
//    public init(frame: CGRect, MFomat: String, SFomat: String) {
    public init(frame: CGRect, value:String) {
        
//        self.MFomat = MFomat;
//        self.SFomat = SFomat;
        
        let values = value.components(separatedBy: ".");
        let mvalue = values.first!;
        let svalue = String.init(format: ".%@", values.last!);
        
        
        let speace: CGFloat = 10;
        let width = (frame.size.width - 3 * speace) / 2;
        
        self.MDateView = DatePickerView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: frame.size.height), value:mvalue);
        self.MDateView.backgroundColor = UIColor.clear;
        self.SDateView = DatePickerView.init(frame: CGRect.init(x: width + speace*2, y: 0, width: width, height: frame.size.height), value:svalue);
        self.SDateView.backgroundColor = UIColor.clear;
        
        
        super.init(frame: frame);
        
        self.coffSubView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffSubView() {
        self.MStyle = .defaultStyle;
        self.SStyle = .defaultStyle;
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        
        self.addSubview(MDateView);
        self.addSubview(SDateView);
        
        self.MDateView.callback = {
            (vale: String) in
            
            self.MValue = vale;
        }
        self.SDateView.callback = {
            (vale: String) in
            
            self.SValue = vale;
        }

    }
    
    func creteDataWith(style: TimeStyle) -> [String] {
        
        var datas: [String] = Array();
        if style == .centisecond {
            
            for i in 0 ..< 10 {
                
                let str = String.init(format: ".%d0", i);
                datas.append(str);
                
            }
            
        } else {
            
            for i in 0 ..< 60 {
                
                let str = String.init(format: "%d", i);
                datas.append(str);
            }
        }
        return datas;
    }
}
