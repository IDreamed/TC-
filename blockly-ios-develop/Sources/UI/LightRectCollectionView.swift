//
//  LightRectCollectionView.swift
//  Blockly
//
//  Created by 张 on 2017/7/21.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class LightRectCollectionView: UIView {

    let selfRuntimeKey = "selfColorKey";
    
    var dataArray: [Int] = Array();
    let panding: CGFloat = 1.0 / 41.5;

    let cellKey: String = "lightRectCell";
    var dataString: String? {
        didSet {
            
            self.createDataSource();
            self.collecton.reloadData();
        }
    }
    lazy var collecton: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init();
        let con = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout);
        con.backgroundColor = UIColor.clear;
        return con;
    }();

    func createDataSource() {
        
        self.dataArray.removeAll();
        if self.dataString == "#image" {
            
            for _ in 0 ..< 64 {
                
                dataArray.append(0);
            }
        } else {
            
            let newStr = self.dataString!.components(separatedBy: "#").last;
            
            for i in 0 ..< 64 {
                let indexStr = newStr![i..<i+2];
                dataArray.append(Int(indexStr)!);
            }
        }
        
        self.collecton.reloadData();
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.coffSubView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffSubView() {
        
        collecton.frame = self.bounds;
        collecton.dataSource = self;
        collecton.delegate = self;
        
        collecton.register(LightRectCell.self, forCellWithReuseIdentifier: cellKey);
        collecton.backgroundColor = UIColor.init(red: 0.133, green: 0.133, blue: 0.133, alpha: 1);
        self.backgroundColor = UIColor.white;
        self.addSubview(collecton);

    }

}

extension LightRectCollectionView : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    open func getColorStringWithIndex(index: Int) -> UIColor {
        
        let path = Bundle.main.path(forResource: "animateColor", ofType: "plist");
        
        let array: [String] = NSArray.init(contentsOfFile: path!) as! [String];
        
        let string = array[index];
        
        return string.uiColor();
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        collecton.frame = self.bounds;

        return dataArray.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecton.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! LightRectCell;
        
        let index = dataArray[indexPath.item];
        
        cell.color = self.getColorStringWithIndex(index: index);
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let top = panding * collectionView.bounds.width;
        return CGSize.init(width: top*4, height: top*4);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let top = panding * collectionView.bounds.width;
        return top;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let top = panding * collectionView.bounds.width;
        return top;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top = panding * collectionView.bounds.width;
        
        return UIEdgeInsetsMake(top, top, top, top);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("select");
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        NSLog("点击了");
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if collecton.frame.contains(point) {
            
            return collecton;
        }
        return super.hitTest(point, with: event);
    }
}

class LightRectCell: UICollectionViewCell {
    
     var color = LightRectCollectionView().getColorStringWithIndex(index: 0) {
        didSet {
            let set = color.bky_rgba();
            self.backgroundColor = color;
            let str = String(format: "%02x%02x%02x", set.red,set.green,set.blue);
            colorStr = str;
        }
    };
    
    var colorStr:String = {
        let color = LightRectCollectionView().getColorStringWithIndex(index: 0);
        let set = color.bky_rgba();
        
        let str = String(format: "%02x%02x%02x", set.red,set.green,set.blue);
        
        return str;
    }();
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        return self;
    }
}
