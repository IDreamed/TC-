//
//  DoFunctionCollection.swift
//  Blockly
//
//  Created by 张 on 2017/6/25.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class DoFunctionCollection: UICollectionView {

    public var datas: [String] = NSArray() as! [String] {
        
        didSet {
            
            self.reloadData();
        }
    }
    
    public var callback: StringCallBack?;
    
    public let cellKey = "DoFunctionCell";
    
    public init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout.init();
        layout.minimumLineSpacing = AlertViewControl.replaceWidth(value: 30);
        layout.minimumInteritemSpacing = AlertViewControl.replaceWidth(value: 30);
        layout.itemSize = AlertViewControl.resize(size: CGSize.init(width: 220, height: 120));
        super.init(frame: frame, collectionViewLayout: layout);
        let pading = AlertViewControl.replaceWidth(value: 30);
        
        self.contentInset = UIEdgeInsets.init(top: pading, left: pading, bottom: pading, right: 0);
        self.bounces = false;
        self.backgroundColor = UIColor.clear;
        self.register(DoFunctionCell.classForCoder(), forCellWithReuseIdentifier: self.cellKey);
        
        self.dataSource = self;
        self.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DoFunctionCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.datas.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellKey, for: indexPath) as! DoFunctionCell;
        
        let name = self.datas[indexPath.item];
        
        cell.nameLabel.text = name;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let name = self.datas[indexPath.item];
        
        if (self.callback != nil) {
            
            self.callback!(name);
        }
    }
}

class DoFunctionCell: UICollectionViewCell {
    
     let nameLabel: UILabel = {
    
        let label = UILabel.init();
        
        label.font = UIFont.systemFont(ofSize: 30);
        
        return label;
    }();
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = AlertViewControl.replaceWidth(value: 20);
        self.backgroundColor = UIColor.clear;
        let backView = WhiteBlackView.init(frame: self.bounds);
        self.addSubview(backView);
        
        let panding = AlertViewControl.replaceWidth(value: 20);
        let width = self.bounds.width - 2 * panding;
        let height = self.bounds.height - 2 * panding;
        self.nameLabel.frame = CGRect.init(x: panding, y: panding, width: width, height: height);
        backView.addSubview(self.nameLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
