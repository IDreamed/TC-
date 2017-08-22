//
//  FourValueView.swift
//  Blockly
//
//  Created by 张 on 2017/6/25.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class FourValueView: UIView {

    public var callbcak: StringCallBack?;
    
    @IBAction func checkClink(_ sender: Any) {
        
        let images = ["bl_yuan_2","bl_sanjiao_2","bl_xingxing_2","bl_fang_2"];
        
        let button = sender as! UIButton;
        let index = button.tag - 500;
        
        if (self.callbcak != nil) {
            
            self.callbcak!(images[index]);
        }
        
    }
   
}
