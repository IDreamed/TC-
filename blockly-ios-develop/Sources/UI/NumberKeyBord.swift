//
//  NumberKeyBord.swift
//  Blockly
//
//  Created by 张 on 2017/5/31.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

typealias StringCallBack = (String)->Void;


class NumberKeyBord: UICollectionView {

    let layout: UICollectionViewFlowLayout;
    let identifier = "keyBordCell";
    var dataArray: [String]?;
    
    var callBack: StringCallBack?;
    
    
    var valueString: String = "0" {
        didSet {
            
            if callBack != nil {
                self.callBack!(valueString);
            }
        }
    };
    
    let clearButton: UIButton = {
    
        let button = UIButton.init(type: UIButtonType.custom);
        button.setTitle("清除", for: .normal);
        button.backgroundColor = UIColor.init(red: 0.322, green: 0.38, blue: 0.945, alpha: 1);
        
        return button;
    }();
    
    public init(frame: CGRect) {
        
        layout = UICollectionViewFlowLayout.init();
        
        
        super.init(frame: frame, collectionViewLayout: layout);
        
        self.coffView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView() {
        
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        self.dataSource = self;
        self.delegate = self;
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        self.bounces = false;
        
        self.register(KeyBordCell.classForCoder(), forCellWithReuseIdentifier: identifier);
        self.backgroundColor = UIColor.white;
        
        self.dataArray = ["7","8","9","4","5","6","1","2","3","-","0","."];
        
        self.reloadData();
        
        let bWidth = self.bounds.width;
        let cellHeight = (self.bounds.width-2)/4;
        let height = self.bounds.height/5;
        
        self.clearButton.frame = CGRect.init(x: 0, y: self.bounds.height/5.0*4, width: bWidth, height: height);
        
        self.clearButton.titleLabel?.font = UIFont.systemFont(ofSize: cellHeight/2);
        self.clearButton.addTarget(self, action: #selector(self.clearClink), for: .touchUpInside);
        self.addSubview(self.clearButton);
        
        
    }
    func clearClink() {
        
        var value = self.valueString;
        if (value.characters.count == 1) {
            
            self.valueString = "0";
            
            return ;
        }
        
        value.remove(at: value.index(before: value.endIndex));
        
        self.valueString = value;
        
    }

}
//MARK: - collection代理方法
extension NumberKeyBord: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray!.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! KeyBordCell;
        let string = self.dataArray![indexPath.item];
        
        cell.label.text = string;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.bounds.width-2) / 3;
        let height = collectionView.bounds.height/5;
        let itemSize = CGSize(width: width, height: height);

        return itemSize;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let value = self.dataArray![indexPath.item];
        
        var currentString = self.valueString;
        
        if currentString.characters.count == 10 {
            return ;
        }
        
        if currentString == "0" {
            
            currentString = "";
        }
        
        if currentString.characters.count == 0 {
            
            if value == "." {
                return ;
            }
        } else {
            
            if value == "-" {
                
                return ;
            }
            
            if currentString == "-" && value == "." {
                return ;
            }
            
            if (currentString.range(of: ".") != nil && value == ".") {
                
                return ;
            }
        }
        
        currentString.append(value);
        
        
        self.valueString = currentString;
        
    }
}
//MARK: - keyBordCell
class KeyBordCell: UICollectionViewCell {
    
    let label: UILabel = UILabel.init();
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.coffSubView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.coffSubView();
    }
    
    func coffSubView() {
        
        label.frame = self.bounds;
        label.font = UIFont.systemFont(ofSize: label.bounds.height/2);
        label.textColor = UIColor.white;
        label.textAlignment = .center;
        self.addSubview(label);
        
        self.backgroundColor = UIColor.init(red: 0.447, green: 0.498, blue: 0.976, alpha: 1);
        label.backgroundColor = UIColor.clear;
    }
}
