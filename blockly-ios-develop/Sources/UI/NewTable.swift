//
//  NewTable.swift
//  Blockly
//
//  Created by 张 on 2017/6/4.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class NewTable: UITableView {

    let cellKey = "NewTableCell";
    var dataSourcr: [RectModel] = Array() {
        didSet {
            self.reloadData();
        }
    };
    var callBack: cellSecect?;
    var rowHight: CGFloat = 0;
    
    public var selectCell: NewTableCell?;
    
    public  init(frame: CGRect, rowHeight: CGFloat) {
        
        self.rowHight = rowHeight;
        
        super.init(frame: frame, style: .grouped);
        
        self.coffView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coffView() {
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = .none;
        
        let bundel = Bundle(identifier: "com.google.blockly.Blockly");
        let cellNib = UINib.init(nibName: cellKey, bundle: bundel);
        self.register(cellNib, forCellReuseIdentifier: cellKey);
        
    }

}

extension NewTable: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSourcr.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.rowHight;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! NewTableCell;
        cell.backgroundColor = UIColor.clear;
        cell.selectionStyle = .none;
        let model = self.dataSourcr[indexPath.row];
        let height = self.tableView(tableView, heightForRowAt: indexPath);
        cell.titleLabel.font = UIFont.systemFont(ofSize: height/2);
        cell.titleLabel.text = model.name;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if selectCell != nil {
            
            selectCell!.backgroundColor = UIColor.clear;
        }
        
        let cell = tableView.cellForRow(at: indexPath);
        
        cell!.backgroundColor = UIColor.init(red: 0.5, green: 0.6, blue: 1, alpha: 1);
        
        self.selectCell = cell as? NewTableCell;
        let model = self.dataSourcr[indexPath.row];
        
        if self.callBack != nil {
            
            self.callBack!(model);
        }
    }
    
    
}
