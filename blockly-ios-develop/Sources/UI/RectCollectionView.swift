//
//  RectCollectionView.swift
//  Blockly
//
//  Created by 张 on 2017/5/25.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

typealias cellSecect = (_ model: RectModel) -> Void;

//MARK: - collection相关
class RectCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - 数据源数组和赋值刷新
    public var modelArray: [RectModel] = Array.init() {
        didSet{
            //根据初始值确定选中的index
            self.getSelectIndex();
            self.reloadData();
            //调整cell间距 实现一排间距相等
            // 判断显示内容是否超出显示区域
            if self.contentSize.width <= self.bounds.width || self.contentSize.height <= self.bounds.height {
                //判断横向一排 竖向一排
                var space: CGFloat = 10;
                if self.bounds.width < 2.3 * cellWidth {
                    
                    space = (self.bounds.height - 20 - cellWidth * CGFloat(modelArray.count)) / CGFloat(modelArray.count + 1);
                    
                    let leftpading = (self.bounds.width - cellWidth)/2;
                    
                    self.layout!.sectionInset = UIEdgeInsets.init(top: space, left: leftpading, bottom: space, right: leftpading);

                }
                
                if self.bounds.height < 2.3 * cellWidth {
                    
                    space = (self.bounds.width - 20 - cellWidth * CGFloat(modelArray.count)) / CGFloat(modelArray.count + 1);
                    let toppading = (self.bounds.height - cellWidth)/2;

                    self.layout!.sectionInset = UIEdgeInsets.init(top: toppading, left: space, bottom: toppading, right: space);
                }
                
                
                self.layout!.minimumLineSpacing = space;
                self.layout!.minimumInteritemSpacing = space
                

                
                self.reloadData();
                
            }
                
        }
            
    };
    
    func getSelectIndex() {
       
        var value = self.initValue!;
        
        if self.initValue!.contains(",") {
            
            let strs = self.initValue!.components(separatedBy: ",");
            if strs[0] != "" {
                
                value = strs[0];
                if value.contains("%") {
                    
                    value = value.components(separatedBy: "%").first!;
                }
                
            } else if strs[1] != "" {
                
                value = strs[1];
            }
            
        }
        
        for i in 0 ..< self.modelArray.count {
            
            let model = modelArray[i];
            if model.value == value {
                
                self.selectIndex = i;
            }
            
            if model.name == value {
                
                self.selectIndex = i;
            }
        }
        
    }
    
    //MARK: - 属性
    
    public var selectCell: cellSecect?;
    
    public var selectIndex: Int = 0;
    
    public var initValue: String?;
    
    public var currentCell: RectCollectionCell?;
    
    public var cellBorderColor: UIColor?;
    
    public var layout: UICollectionViewFlowLayout?;
    
    public var cellWidth: CGFloat = 0;
    
    
    public  init(frame: CGRect, cellWidth: CGFloat, scrollDirection: UICollectionViewScrollDirection , value: String) {
        
        let layout = UICollectionViewFlowLayout.init();
        
        layout.scrollDirection = scrollDirection;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSize.init(width: cellWidth, height: cellWidth);
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
        
        self.initValue = value;
        
        self.layout = layout;
        
        self.cellWidth = cellWidth;
        
        super.init(frame: frame, collectionViewLayout: layout);
        
        self.coffView(cellWidth: cellWidth);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView(cellWidth: CGFloat) {
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 20;
        self.bounces = false;
        self.dataSource = self;
        self.delegate = self;
        self.register(RectCollectionCell.classForCoder(), forCellWithReuseIdentifier: RectCollectionCell.identifier);
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.modelArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: RectCollectionCell.identifier, for: indexPath) as! RectCollectionCell;
        
        let model = modelArray[indexPath.item];
        
        cell.model = model;
        
        if self.cellBorderColor != nil {
            
            cell.layer.borderColor = self.cellBorderColor!.cgColor;
        }
        
        if self.selectIndex == indexPath.item {
            
            cell.layer.borderWidth = 2;
            self.currentCell = cell;
        }
        
        cell.configSubView();
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog("%d", indexPath.item);
        self.selectIndex = indexPath.item;
        let cell = self.cellForItem(at: indexPath) as! RectCollectionCell;
        if (self.currentCell == cell) {
            
            return;
        }
        
        if (self.currentCell != nil) {
            
            self.currentCell!.layer.borderWidth = 0;
        }
        
       

        cell.layer.borderWidth = 2;
        
        let model = self.modelArray[indexPath.item];
        self.currentCell = cell;
        
        if self.selectCell != nil {
            
            self.selectCell!(model);
        }
        
    }
    
}

//MARK: - --------collectionCell
public class RectCollectionCell: UICollectionViewCell {
    
    static let identifier = "RectCollectionCell";
    
    var model: RectModel = {
        
        return RectModel();
    }();
    
    
    let imageView: UIImageView = {
        
        let image = UIImageView.init();
        image.contentMode = .scaleAspectFit;
        
        image.layer.masksToBounds = true;
        image.layer.cornerRadius = 10;
        return image;
        
    }();
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        self.configSubView();
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        
        super.init(coder: aDecoder);
        self.configSubView();

        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubView() {
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = UIColor.orange.cgColor;
        self.backgroundColor = UIColor.init(red: 0.482, green: 0.745, blue: 0.973, alpha: 1);

        
        if self.imageView.superview == nil {
            
            self.addSubview(self.imageView);
        }
        
        let width = self.contentView.bounds.width - 20;
        let height = self.contentView.bounds.height - 20;
        
        self.imageView.frame = CGRect.init(x: 10, y: 10, width: width, height: height);
        
        let colors = ["白","黑","红","橙","蓝","绿","紫","青"];
        if colors.contains(model.name) {
            
            self.setBackGroundColorWith(name: model.name);
            
        } else {
            let image = UIImage.init(named: self.model.image);
        
            self.imageView.image = image;
        }
    }
    
    func setBackGroundColorWith(name: String) {
        
        var color: UIColor = UIColor.init();
        
        switch name {
        case "白":
            color = UIColor.white;
            break;
        case "黑" :
            color = UIColor.black;
            break;
        case "红" :
            color = UIColor.red;
            break;
        case "橙" :
            color = UIColor.yellow;
            break;
        case "蓝" :
            color = UIColor.blue;
            break;
        case "绿" :
            color = UIColor.green;
            break;
        case "紫" :
            color = UIColor.purple;
            break;
        case "青" :
            color = UIColor.cyan;
            break;
        default: break
            
        }
        
        self.backgroundColor = color;
    }
}
