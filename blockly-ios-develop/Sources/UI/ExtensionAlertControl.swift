//
//  ExtensionAlertControl.swift
//  Blockly
//
//  Created by 张 on 2017/6/3.
//  Copyright © 2017年 Google Inc. All rights reserved.
//

import UIKit

class ExtensionAlertControl: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
//对弹窗的类扩展
//MARK: -创建弹窗内容
extension AlertViewControl {
    
    //根据type创建弹窗
    func createSubView() {
        
        if self.name == "while" {
            
            self.backView!.ABStyle = .noFoot;
            self.createWhileView(title: "当");
        } else if ["move_left","move_right"].contains(self.name) {
            
            self.createAngleView();
            
        } else if ["move_ahead","move_back"].contains(self.name) {
            
            self.createMoveView();
        } else if self.name == "machine_speed_direction" {
            self.createMachineSpeedDirection();
        } else if self.name == "machine_speed" {
            
            self.createMachineSpeed();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "machine_angle_direction" {
            self.createMachineAngleDirection();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "machine_stop" {
            self.createMachineStop();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "machine_two_stop" {
            self.createMachineTwoStop();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "fan_speed" {
            self.createFanSpeed();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "fan_stop" {
            
            self.createMachineStop();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "machine_swing" {
            self.createMachineSwing();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "light_on_off" {
            self.createLightOnOff(name: "RGB-LED灯");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "light_caution_on_off" {
            self.createLightCautionOnOff();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "light_color" {
            self.createLightColor();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "highlight_level" {
            self.createHighlightLevel();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "highlight_on_off" {
            self.createLightOnOff(name: "高亮LED灯");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "light1" {
            self.createLight1();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "light2" {
            self.createLightOnOff(name: "灯格");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "daily_words" {
            self.createDailyWords(title: "生活", values: ["wuwuwu","打呼噜","打雷","东西掉地上", "欢呼", "口哨", "冒泡", "亲吻","跳水"]);
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "music_sound" {
            self.createDailyWords(title: "音乐", values: ["bibibibibi","bling","duang","生日歌","数码声","小号声","旋律"]);

            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "animal_sound" {
            self.createDailyWords(title: "动物", values: ["狗啃骨头","狗狂吠","恐龙","猫叫","鸟叫","青蛙叫"]);
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "transport_sound" {
            self.createDailyWords(title: "交通", values: ["车鸣笛","船鸣笛","飞机起飞","火车鸣笛","警车鸣笛","拖拉机"]);
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "buzzer_on_off" {
            self.createOnOffView(names: ["kaishi_yousheng7","kaishi_wusheng8"], title: "蜂鸣器");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "buzzer_level" {
            self.createBuzzerLevel();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "own_sound" {
            
        } else if self.name == "port_on_off" {
            
            self.createPortOnOff();
            self.updataTitleWithValues(values: self.block!.getBlockValues());
        
        } else if self.name == "port_type" {
            
            self.createPortType();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "port_in" {
            self.createPortIn();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "port_out" {
            self.createPortOut();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "function" {
            
            self.createFuncation();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "do_function" {
            
            self.createDoFunction();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "long_time" {
            self.createLongTime();

        } else if self.name == "random_time" {
            self.createRandomTime(title:"随机等待", uinit:"秒");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "always_repeat" {
            
        } else if self.name == "repetition_num" {
            self.createRandomTime(title: "重复", uinit: "次");

        } else if self.name == "repetition_until1" {
            
            self.createWhileView(title: "重复直到");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "repetition_until2" {
            self.createTwoAlert(title: "重复直到");

        } else if self.name == "if" {
            self.createWhileView(title: "如果");
//            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "if2" {
            self.createTwoAlert(title: "如果");
//            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "if_else" {
            self.createWhileView(title: "如果");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "if_else2" {
            self.createTwoAlert(title: "如果");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "set_value" {
            self.createSetValue();

        } else if self.name == "use_change" {
            self.createUseChange();

        } else if self.name == "do_some" {
            
        } else if self.name == "variable_repetition_num" {
            self.createVariableRepetitionNum();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "variable_repetition" {
            self.createVariableIf(title: "重复");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "variable_if" {
            self.createVariableIf(title: "如果");
            self.updataTitleWithValues(values: self.block!.getBlockValues());


        } else if self.name == "variable_if_else" {
            self.createVariableIf(title: "如果");
            self.updataTitleWithValues(values: self.block!.getBlockValues());
        } else if self.name == "wait_port_open" {
            
            self.createWaitPortOpen();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

            
        } else if self.name == "wait_do" {
            
            self.createWhileView(title: "等待");
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "set_timer_unit" {
            
            self.createSetTimerUnit();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "math_operator" {
        
            self.createMathOperator();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "math_even" {
            self.createMathEvent();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "math_integer" {
            self.createMathInteger();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "math_trans" {
            self.createMathTrans();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        } else if self.name == "math_random" {
            self.createMathRandom();
            self.updataTitleWithValues(values: self.block!.getBlockValues());

        }
        
    }
    
    //MARK: - while的弹窗
    func createWhileView(title: String) {
        
        let values = self.block!.getBlockValues();
        
        self.createTitleView(titles: [title,"按钮被触碰","端口",values.last!], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        self.backView!.ABStyle = .noFoot;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let leftPanding: CGFloat = AlertViewControl.replaceWidth(value: 35);
        let topPanding: CGFloat = AlertViewControl.replaceWidth(value: 30);
        
        let cWidth = self.backView!.bounds.width - leftPanding * 2;
        let cHeight = self.backView!.contextHeight - topPanding * 3;
        
        let cellWidth = AlertViewControl.replaceWidth(value: 110);
        
        let coloction = RectCollectionView.init(frame: CGRect.init(x: leftPanding, y: topPanding*2, width: cWidth, height: cHeight/3), cellWidth: cellWidth, scrollDirection: .vertical, value: values[0]);
        coloction.cellBorderColor = self.backColor;

        let images = ["kaishi_anniu_zhong2","kaishi_yanse6","kaishi_yousheng7","kaishi_hongwai_11","gj_youyali","kaishi_liangdu16"];//,"gj_tuoluoyi"
        
        let names = ["按钮被触碰","颜色","听到声音","红外线","有压力","亮度"];//,"陀螺仪"
        var dataArray: [RectModel] = Array();
        for i in 0 ..< images.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            
            dataArray.append(model);
        }
        coloction.modelArray = dataArray;
        
        coloction.center = CGPoint.init(x:  self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);
        
        //
        let view: SetPointView = SetPointView.init(frame: CGRect.init(x: leftPanding, y: 2*topPanding + cHeight/2, width: cWidth, height: cHeight/3), type: self.block!.name, value: values.last!);
        
        view.callBack = {
            [weak self](value: String) in
            self!.update(value: value, viewIndex: 1);
        };
        view.isHidden = (values.first! == "按钮被触碰");
        view.center = CGPoint.init(x: coloction.center.x, y: coloction.center.y*3);
        //
        coloction.selectCell = {
            [weak self](model: RectModel) in
            
            if model.name != "按钮被触碰" {
                
                self!.backView!.ABStyle = .noFoot;
                view.isHidden = false;
                
                if view.currentTitle != nil {
                    self!.update(value: view.currentTitle!.titleLabel!.text!, viewIndex: 1);
                    
                } else {
                    self!.update(value: "IN1", viewIndex: 1);
                }
                
            } else {
                
                self!.backView!.ABStyle = .noFootShout;
                view.isHidden = true;
                self!.update(value: "无", viewIndex: 1);
            }
            
            self!.models.removeAll();
            self!.models.append(model);
            if values.first!.contains("%") && model.name == "亮度" {
                
                var lightValue = values.first!.components(separatedBy: "%").first!;
                lightValue = lightValue.components(separatedBy: "亮度").last!;
                model.value = lightValue;
            }
            
            self!.updateTitle(model: model, index: 0);
        };
        
        
        self.backView!.contextView.addSubview(coloction);
        self.backView!.contextView.addSubview(view);
        
        self.getWhileAttStringWith(value: values[0], index: 0);
        
    }
    
    func getWhileAttStringWith(value: String, index: Int) {
        
        let model = RectModel.init();
        
        if value.contains(",") {
            
            let array = value.components(separatedBy: ",");
            
            if array[0] != "" {
                
                let newValue = array[0];
                
                if newValue.contains("%") {
                    
                    model.name = "亮度";
                    model.value = newValue.components(separatedBy: "%")[0];
                    model.value = model.value.components(separatedBy: "亮度").last!
                    
                } else {
                    
                    model.name = newValue;
                    model.value = newValue;
                    
                }

                
            } else if array[1] != "" {
                model.name = "颜色";
                model.value = array[1];
            }
        } else {
        
            if value.contains("yanse") {
                
                model.name = "颜色";
                model.value = value;
                
            } else if value.contains("%") {
                
                model.name = "亮度";
                model.value = value.components(separatedBy: "%")[0];
                model.value = model.value.components(separatedBy: "亮度").last!
                
            } else {
                
                model.name = value;
                
            }
        }
        
        self.models.removeAll();
        self.models.append(model);
        self.updateTitle(model: model, index: index);
    }
    
    //调整弹窗和footView
    func updateTitle(model: RectModel, index:Int) {
        
        if model.name == "颜色" {
            
            self.backView!.ABStyle = .defaultStyle;
            
            let images = ["gj_yanse_bai_1","gj_yanse_hei_1","gj_yanse_hong_1","gj_yanse_lv_1","gj_yanse_lan_1","gj_yanse_cheng_1"];
            let colors = ["白","黑","红","绿","蓝","橙"];
            
            self.addFootViewCollctionWith(names: colors, images: images, selectCallBack: {
                (model: RectModel) in
                
                self.models[0].value = model.image;
                self.updateWhileValue(index: index);
                
            });
            
        } else if model.name == "陀螺仪" {
            
            self.backView!.ABStyle = .defaultStyle;
            
            let names = ["左倾","右倾","前倾","后倾","上升","下降","静止"];
            
            let images = ["kaishi_buwanqu9","kaishi_buwanqu9","kaishi_buwanqu9","kaishi_buwanqu9","kaishi_buwanqu9","kaishi_buwanqu9","kaishi_buwanqu9"];
            
            self.addFootViewCollctionWith(names: names, images: images, selectCallBack: {
                (model: RectModel) in
                
                self.models[0].value = model.name;
                self.updateWhileValue(index: index);
            });
            
            
            
        } else if model.name == "亮度" {

            
            self.backView!.ABStyle = .defaultStyle;
            self.addLightFootView(index: index, value: model.value);
            
        } else {
            
            self.backView!.ABStyle = .noFoot;
            
        }
        
        self.updateWhileValue(index: index);
    }
    
    //更新title显示
    func updateWhileValue(index: Int) {
        
        
        let label = self.imputViews[index] as! UILabel;
        let model = self.models[0];
        let atrString = NSMutableAttributedString.init();
        var setValue = "";
        var port = self.currentPort;
        if self.currentIndex == nil {
          
            port = "";
        } else {
            
            if port == nil {
                
                if model.name == "按钮被触碰" {
                    port = "无";
                } else {
                    port = "IN1";
                }
            }
        }
        
        
        if self.models[0].name == "颜色" {
            
            let titleHeight = self.backView!.titleHeight / 2;
            let fontsize = titleHeight / 4 * 3;
            
            if self.models[0].value == "" {
                
                self.models[0].value = "gj_yanse_hong_1";
            }
            
            let string = NSMutableAttributedString.init();
            
            let image = UIImage.init(named: self.models[0].value);
            
            let textat = NSTextAttachment.init();
            textat.image = image;
            textat.bounds = CGRect.init(x: 0, y: 0, width: fontsize*2, height: fontsize);
            string.append(NSAttributedString.init(attachment: textat));
            
            atrString.append(string);
            
            setValue = String.init(format: ",%@,%@", self.models[0].value,port!);
            
        } else if self.models[0].name == "陀螺仪" {
            
            let subString = NSAttributedString.init(string: String.init(format: "%@", self.models[0].value));
            
            atrString.append(subString);
            
            setValue = self.models[0].value;
            setValue = String.init(format: "%@,,%@", self.models[0].value,port!);
        } else if self.models[0].name == "亮度" {
            
            
            if models[0].value == "" {
                
                models[0].value = "0";
            }
            
            let subString = NSAttributedString.init(string: String.init(format: "%@%d%%", "亮度",Int(self.models[0].value)!));
            
            atrString.append(subString);
            
            setValue = String.init(format: "%@%d%%", self.models[0].name,Int(self.models[0].value)!);
            setValue = String.init(format: "%@,,%@", setValue,port!);
            
        } else if self.models[0].name == "bianliang" {
            
            let titleHeight = self.backView!.titleHeight / 2;
            let fontsize = titleHeight / 4 * 3;
            
            if self.models[0].value == "" {
                
                self.models[0].value = "bl_yuan_2";
            }
            
            let string = NSMutableAttributedString.init();
            
            let image = UIImage.init(named: self.models[0].value);
            
            let textat = NSTextAttachment.init();
            textat.image = image;
            textat.bounds = CGRect.init(x: 0, y: 0, width: fontsize, height: fontsize);
            string.append(NSAttributedString.init(attachment: textat));
            
            atrString.append(string);
            
            setValue = String.init(format: ",%@,%@", self.models[0].value,port!);
            
        } else {
            
            
            let subString = NSAttributedString.init(string: String.init(format: "%@", self.models[0].name));
            
            atrString.append(subString);
            
            setValue = String.init(format: "%@,,%@", self.models[0].name,port!);
            
        }
        
        label.attributedText = atrString;
        objc_setAssociatedObject(label, &runtimeKey.alertKey, setValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        
    }
    //添加亮度view
    func addLightFootView(index:Int, value:String) {
        
        self.backView!.footView.setNeedsLayout();
        self.backView!.footView.layoutIfNeeded();
        
        _ = self.backView!.footView.subviews.map {
            $0.removeFromSuperview();
        };
        let leftPanding: CGFloat = 35;
        let topPanding: CGFloat = 30;
        
        let width = self.backView!.bounds.width - leftPanding * 2;
        let height = self.backView!.footView.bounds.height - topPanding * 2;
//        let level = value.components(separatedBy: "亮度").last!;
        let slider = NewSlider.init(frame: CGRect(x:leftPanding, y:0, width:width, height: height), hasGraduation: false , value: value);
        
        slider.callBack = {
            (value: Int) in
            
            self.models[0].value = String.init(value);
            
            self.updateWhileValue(index: index);
            
        };
        
        self.backView!.footView.addSubview(slider);
    }
    
    //添加collectionFootView
    func addFootViewCollctionWith(names: [String], images: [String], selectCallBack: @escaping cellSecect) {
        
        self.backView!.footView.setNeedsLayout();
        self.backView!.footView.layoutIfNeeded();
        
        _ = self.backView!.footView.subviews.map {
            $0.removeFromSuperview();
        };
        
        let leftPanding: CGFloat = AlertViewControl.replaceWidth(value: 35);
        let topPanding: CGFloat = AlertViewControl.replaceWidth(value: 30);
        
        let width = self.backView!.bounds.width - leftPanding * 2;
        let height = self.backView!.footView.bounds.height - topPanding;
        let cellWidth = height - 20;
        
        var value = block!.getBlockValues().first!;
        
        if value.contains(",") {
            
            value = value.components(separatedBy: ",")[1];

        }
        
        if value == "" {
            
            value = "gj_yanse_hong_1";
        }
        
        let colorColl = RectCollectionView.init(frame: CGRect.init(x: leftPanding, y: 0, width: width, height: height), cellWidth: cellWidth, scrollDirection: .horizontal, value: value);
        
        colorColl.cellBorderColor = self.backColor;
        
        var models: [RectModel] = Array();
        
        for i in 0 ..< names.count {
            
            let model = RectModel.init();
            
            model.name = names[i];
            model.image = images[i];
            models.append(model);
        }
        colorColl.modelArray = models;
        
        colorColl.selectCell = selectCallBack;
        
        colorColl.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .left);
        
        self.backView!.footView.addSubview(colorColl);
    }
}

//MARK: - 移动弹窗
extension AlertViewControl {
    
    func createAngleView() {
        
        var title = "向左转";
        if self.name == "move_right" {
            title = "向右转";
        }
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        
        
        let clockHeight = self.backView!.contextHeight - 10;
        
        
        var views: [UILabel] = Array();
        
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = title;
        views.append(label1);
        let label2 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label2.text = "0˚";
        views.append(label2);
        
        self.addTitleLayoutWith(views: views);
        
        let clockView = ClockView.init(frame: CGRect.init(x: 0, y: 0, width: clockHeight, height: clockHeight));
        clockView.center.x = self.backView!.bounds.width/2;
        
        clockView.clockCallBack = {
            (value: Int) in
            
            self.updateAngleValue(value: value);
        };
        
        self.backView!.contextView.addSubview(clockView);
        
        //初始化
        self.updateAngleValue(value: 0);
    }
    
    //更新角度
    func updateAngleValue(value: Int) {
        
        let label = self.imputViews[0] as! UILabel;
        label.text = String.init(format: "%d˚", value);
        
        self.setRuntime(value: label.text!, objct: label);
    }
    
    //前进后退弹窗
    func createMoveView() {
        
        self.backView!.ABStyle = .noFoot;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let resize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 80));
        let leftPading = resize.width;
        let topPading = resize.height;
        let titleHeight = self.backView!.titleHeight / 2;
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        
        
        var views: [UILabel] = Array();
        
        let label = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label.text = "距离";
        views.append(label);
        
        let label1 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label1.text = "0";
        
        views.append(label1);
        
        let label2 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label2.text = "cm";
        views.append(label2);
        
        let label3 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        
        label3.text = "0%";
        
        views.append(label3);
        
        self.addTitleLayoutWith(views: views);
        
        
        let backViewWidth = self.backView!.bounds.width - leftPading * 2;
        let backViewHeight = self.backView!.contextHeight - topPading * 2;
        
        let backResize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 60));
        
        let ruleHeight = AlertViewControl.replaceWidth(value: 100);
        
        let proWidth = backViewWidth - backResize.width * 2;
        let proHeight = backViewHeight - ruleHeight - backResize.height * 3;
        
        let view = WhiteBlackView.init(frame: CGRect.init(x: leftPading, y: topPading, width: backViewWidth, height: backViewHeight));
        
        let rule = NewRule.init(frame: CGRect.init(x: backResize.width, y: backResize.height, width: proWidth, height: ruleHeight));
        rule.storkeColor = self.backColor;
        
        rule.callBack = {
            (value: Int) in
            
            self.updateMoveValue(count: 0, value: value);
        };
        view.addSubview(rule);
        
        let progress = NewSlider.init(frame: CGRect.init(x: 0, y: ruleHeight + backResize.height * 2, width: proWidth, height: proHeight), hasGraduation: true, value: "");
        progress.backgroundColor = UIColor.clear;
//        progress.center.x = self.backView!.bounds.width/2;
        view.addSubview(progress);
        
        progress.callBack = {
            (value: Int) in
            
            self.updateMoveValue(count: 1, value: value);
        };
        
        self.backView!.contextView.addSubview(view);
        
        //初始化
        self.updateMoveValue(count: 0, value: 0);
        self.updateMoveValue(count: 1, value: 0);
        
    }
    
    func updateMoveValue(count: Int, value: Int) {
        
        let label = self.imputViews[count] as! UILabel;
        
        var string = "";
        if count == 0 {
            
            string = String.init(format: "%d", value);
        } else {
            string = String.init(format: "%d%%", value);
        }
        
        label.text = string;
        
        self.setRuntime(value: label.text!, objct: label);
    }
}

//MARK: - 电机弹窗扩展
extension AlertViewControl {

    
    
    
    //风扇速度调整弹窗
    func createFanSpeed() {
        
        self.backView!.ABStyle = .noFootShout;
    
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        self.createTitleView(titles: ["风扇速度","%0","端口","OUT2"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        let values = self.block!.getBlockValues();
        
        let backView = self.createWhiteBackView();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 35);
        
        let slidWidth = backView.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading * 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: topPading, width: slidWidth, height: slidHeight), type: name, value: values[0]);
        setPoint.center.x = self.backView!.bounds.width/2;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        
        backView.frame = CGRect.init(x: leftPading, y: topPading*2 + slidHeight, width: backView.bounds.width, height: self.backView!.contextHeight/2-topPading);
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: slidWidth, height: slidHeight), hasGraduation: false, value: values[0]);
        slider.center.x = backView.bounds.width/2;
        slider.center.y = backView.bounds.height/2;
        slider.backgroundColor = UIColor.clear;
        
        backView.addSubview(slider);
        
        slider.callBack = {
            (value: Int) in
            
            let valueStr = String.init(format: "%d%%", value);
            self.update(value: valueStr, viewIndex: 1);
        };
        
        self.backView!.contextView.addSubview(backView);
    }
    
    //震动等级
    func createMachineSwing() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["端口","OUT1","震动电机频率","0级"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let values = self.block!.getBlockValues();
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 60);
        
        let backView = self.createWhiteBackView();

        
        let slidWidth = self.backView!.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading*1.5;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: backView.bounds.width, height: slidHeight), type: name, value: values[0]);
        setPoint.center = CGPoint.init(x: self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);

        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
       self.backView!.contextView.addSubview(setPoint);
        
        
        backView.frame.size.width = slidWidth;
        backView.frame.size.height = slidHeight;
        backView.center = CGPoint.init(x: setPoint.center.x, y: setPoint.center.y*2.8);
        var value: String = values[1];
        value = value.components(separatedBy: "级")[0];
        let live = NewLiveView.init(frame:  CGRect.init(x: 0,
                                                        y: 0,
                                                        width: slidWidth - leftPading * 2,
                                                        height: backView.bounds.height - topPading),
                                                        levelCount:10,
                                                        value:value);
        
        live.progressColor = block!.color;
        
        live.center = CGPoint.init(x: backView.bounds.width/2, y: backView.bounds.height/2);
        
        live.callBack = {
            (value: Int) in
            
            let valueStr = String.init(format: "%d级", value);
            
            self.update(value: valueStr, viewIndex: 1);
        };
        
        backView.addSubview(live);
        self.backView!.contextView.addSubview(backView);
}
    
    func createMachineSpeedDirection() {
        
        self.backView!.ABStyle = .noFootLong;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        
        var views: [UIView] = Array();
        
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "设置电机";
        views.append(label1);
        let label2 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label2.text = "OUT2";
        self.setRuntime(value: label2.text!, objct: label2);
        views.append(label2);
        
        let label3 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label3.text = "0%";
        views.append(label3);
        self.setRuntime(value: label3.text!, objct: label3);
        
        let iWidth = titleHeight/5.0*3.0 + 8;
        
        let imageView = self.returmImageView(width: iWidth, image: "dj_shunshizhen_1");
        self.setRuntime(value: "dj_shunshizhen_1", objct: imageView);
        views.append(imageView);
    
        let label4 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label4.text = "0.00";
        views.append(label4);
        self.setRuntime(value: label4.text!, objct: label4);
        
        let label5 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        
        label5.text = "秒";
        
        views.append(label5);
        
        self.addTitleLayoutWith(views: views);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let values = self.block!.getBlockValues();
        let height = self.backView!.contextHeight / 5;
        
        let collecWidth = self.backView!.bounds.width / 5 * 3;
        
        let centerX = self.backView!.bounds.width / 2;

        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), type: name, value: values[0]);
        setPoint.layer.backgroundColor = UIColor.clear.cgColor;
        setPoint.center.x = centerX;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        self.backView!.contextView.addSubview(setPoint);
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: self.backView!.bounds.width, height: height), hasGraduation: true, value: values[1]);
        slider.backgroundColor = UIColor.clear;
        let center = CGPoint.init(x: centerX, y: setPoint.center.y + height);
        slider.center = center;
        slider.callBack = {
            (value: Int) in
            let str = String.init(format: "%d%%", value);
            self.update(value: str, viewIndex: 1);
        };
        
        let angleView = RectCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.backView!.bounds.width/2, height: height), cellWidth: AlertViewControl.replaceWidth(value: 110), scrollDirection: .vertical, value:values[0]);
        angleView.center = CGPoint.init(x: slider.center.x, y: slider.center.y + height);
        
        let aNames = ["dj_shunshizhen_1","dj_nishizhen_1"];
        let aImages = ["dj_shunshizhen","dj_nishizhen"];
        var aData: [RectModel] = Array();
        for i in 0 ..< aNames.count {
            
            let model = RectModel.init();
            model.name = aNames[i];
            model.image = aImages[i];
            aData.append(model);
        }
        angleView.modelArray = aData;
        angleView.cellBorderColor = self.backColor;
        
        angleView.selectCell = {
            (model: RectModel) in
            let image = model.name;
            self.updateImage(value: image, viewIndex: 2);
        };
        angleView.backgroundColor = UIColor.clear;
        self.backView!.contextView.addSubview(slider);
        self.backView!.contextView.addSubview(angleView);
        
        let value = self.block!.getBlockValues().last!;
        let dateView = DataPickerControl.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height*1.5), value: value);
        dateView.SStyle = .centisecond;
        
        dateView.center = CGPoint.init(x: centerX, y: angleView.center.y + height*1.5);
        
        dateView.callBack = {
            (value: String) in
            
            self.update(value: value, viewIndex: 3);
        }
        
        self.backView!.contextView.addSubview(dateView);
    }
    
    func createMachineSpeed() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["设置电机","A","0%","dj_shunshizhen_1"],
                             isEnables: [false,true,true,true],
                             isLabels: [true,true,true,false]);
        
        var values = self.block!.getBlockValues();
        
        
        let backView = self.createWhiteBackView();
        backView.backgroundColor = UIColor.clear;
        
        let height = self.backView!.contextHeight / 4;
        
        let collecWidth = self.backView!.bounds.width / 5 * 3;
        
        let centerX = self.backView!.bounds.width / 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), type: name, value: values[0]);
        setPoint.center.x = centerX;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        backView.addSubview(setPoint);
        
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: self.backView!.bounds.width, height: height), hasGraduation: true, value: values[1]);
        slider.backgroundColor = UIColor.clear;
        let center = CGPoint.init(x: centerX, y: setPoint.center.y + height);
        slider.center = center;
        slider.callBack = {
            (value: Int) in
            let str = String.init(format: "%d%%", value);
            self.update(value: str, viewIndex: 1);
        };
        
        let angleView = RectCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.backView!.bounds.width/2, height: height), cellWidth: AlertViewControl.replaceWidth(value: 110), scrollDirection: .vertical, value: values[0]);
        angleView.center = CGPoint.init(x: slider.center.x, y: slider.center.y + height);
        
        let aNames = ["dj_shunshizhen_1","dj_nishizhen_1"];
        let aImages = ["dj_shunshizhen","dj_nishizhen"];
        var aData: [RectModel] = Array();
        for i in 0 ..< aNames.count {
            
            let model = RectModel.init();
            model.name = aNames[i];
            model.image = aImages[i];
            aData.append(model);
        }
        angleView.modelArray = aData;
        angleView.cellBorderColor = self.backColor;
        
        angleView.selectCell = {
            (model: RectModel) in
            let image = model.name;
            self.updateImage(value: image, viewIndex: 2);
        };
        angleView.backgroundColor = UIColor.clear;
        backView.addSubview(slider);
        backView.addSubview(angleView);
        
        self.backView!.contextView.addSubview(backView);
    }
    
    func createMachineAngleDirection() {
        
        self.backView!.ABStyle = .noFootLong;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        let iWidth = titleHeight/5.0*3.0 + 8;
        var views: [UIView] = Array();
        
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "设置电机";
        views.append(label1);
        let label2 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label2.text = "A";
        self.setRuntime(value: label2.text!, objct: label2);
        views.append(label2);
        
        let label3 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label3.text = "0˚";
        views.append(label3);
        self.setRuntime(value: label3.text!, objct: label3);
        
        let imageView = self.returmImageView(width: iWidth, image: "dj_shunshizhen_1");
        self.setRuntime(value: "dj_shunshizhen_1", objct: imageView);
        views.append(imageView);
        
        self.addTitleLayoutWith(views: views);
        
        let height = self.backView!.contextHeight / 4;
        
        let collecWidth = self.backView!.bounds.width / 5 * 3;
        
        let centerX = self.backView!.bounds.width / 2;
        
        let ABCView = RectCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), cellWidth: AlertViewControl.replaceWidth(value: 110), scrollDirection: .vertical, value: "");
        let names = ["A","B","C","D"];
        let images = ["machine_A","machine_B","machine_C","machine_D"];
        
        var data: [RectModel] = Array();
        for i in 0 ..< names.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            
            data.append(model);
        }
        
        ABCView.modelArray = data;
        ABCView.backgroundColor = UIColor.clear;
        ABCView.center.x = centerX;
        ABCView.cellBorderColor = self.backColor;
        ABCView.selectCell = {
            (model: RectModel) in
            
            self.update(value: model.name, viewIndex: 0);
        };
        
        
        let clockView = ClockView.init(frame: CGRect.init(x: 0, y: 0, width: height*2.5, height: height*2.5));
        
        clockView.clockCallBack = {
            (value: Int) in
            
            let str = String.init(format: "%d˚", value);
            self.update(value: str, viewIndex: 1);
        };
        
        clockView.center = CGPoint.init(x: centerX, y: self.backView!.contextHeight/2);
        self.backView!.contextView.addSubview(clockView);
        
        let angleView = RectCollectionView.init(frame: CGRect.init(x: 0, y: self.backView!.contextHeight - height, width: self.backView!.bounds.width/2, height: height), cellWidth: AlertViewControl.replaceWidth(value: 110), scrollDirection: .vertical, value: "");
        angleView.center.x = centerX;
        
        let aNames = ["dj_shunshizhen_1","dj_nishizhen_1"];
        let aImages = ["dj_shunshizhen","dj_nishizhen"];
        var aData: [RectModel] = Array();
        for i in 0 ..< aNames.count {
            
            let model = RectModel.init();
            model.name = aNames[i];
            model.image = aImages[i];
            aData.append(model);
        }
        angleView.modelArray = aData;
        angleView.cellBorderColor = self.backColor;
        
        angleView.selectCell = {
            (model: RectModel) in
            let image = model.name;
            self.updateImage(value: image, viewIndex: 2);
        };
        angleView.backgroundColor = UIColor.clear;
        self.backView!.contextView.addSubview(angleView);
        
        self.backView!.contextView.addSubview(ABCView);

    }
    //停止单个电机
    func createMachineStop() {
        
        
        let values = block!.getBlockValues();
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        var views: [UIView] = Array();
        
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "停止电机";
        views.append(label1);
        let label2 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label2.text = "A";
        self.setRuntime(value: label2.text!, objct: label2);
        views.append(label2);
        
        self.addTitleLayoutWith(views: views);
        
        let height = self.backView!.contextHeight / 2;
        
        let collecWidth = self.backView!.bounds.width / 5 * 4;
        
        let centerX = self.backView!.bounds.width / 2;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), type: name, value: values[0]);
        setPoint.center.x = centerX;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        setPoint.center = CGPoint.init(x: centerX, y: self.backView!.contextHeight/2);

        self.backView!.contextView.addSubview(setPoint);
        
    }
    
    func createMachineTwoStop() {
        
        let values = block!.getBlockValues();
        self.backView!.ABStyle = .noFoot;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let resize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        var views: [UIView] = Array();
        
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "停止电机";
        views.append(label1);
        let label2 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label2.text = "A";
        self.setRuntime(value: label2.text!, objct: label2);
        views.append(label2);
        
        let label3 = self.returnLabel(textColor: UIColor.black, font: font, isChange: true);
        label3.text = "B";
        views.append(label3);
        self.setRuntime(value: label3.text!, objct: label3);
        
        self.addTitleLayoutWith(views: views);
        
        let backViewWidth = self.backView!.contextView.bounds.width - leftPading * 2;
        let backViewHeight = self.backView!.contextHeight - topPading * 3;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: leftPading, y: topPading, width: backViewWidth, height: backViewHeight/2), type: name, value: values[0]);
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        let setPoint1 = SetPointView.init(frame: CGRect.init(x: leftPading, y: backViewHeight/2 + topPading*2, width: backViewWidth, height: backViewHeight/2), type: name, value: values[1]);
        
        setPoint1.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 1);
        };
        

        self.backView!.contextView.addSubview(setPoint);
        self.backView!.contextView.addSubview(setPoint1);
    }
    
    //MARK: - 灯光的弹窗
    //灯 打开关闭
    func createLightOnOff(name: String) {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let values = block!.getBlockValues();
        
        self.createTitleView(titles: ["端口","OUT2",name,"dg_dengmie_1"], isEnables: [false,true,false,true], isLabels: [true,true,true,false]);
        
        let view = self.createWhiteBackView();
        
        let pading = AlertViewControl.replaceWidth(value: 60);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height/2 - 0.5*pading;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collWidth, height: collheight), type: block!.name, value: values[0])
        setPoint.center = CGPoint.init(x: self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);
        
        setPoint.callBack = {
            [weak self](value: String) in
            
            self!.update(value: value, viewIndex: 0);
        };
        self.backView!.contextView.addSubview(setPoint);
        
        view.frame.size = CGSize.init(width: collWidth, height: collheight);
        view.center = CGPoint.init(x: setPoint.center.x, y: setPoint.center.y*2.8);
        
        let coll = self.createTwoButtom(frame: CGRect.init(x: 0, y: 0, width: collWidth, height: collheight), cellWidth: collheight-20, scrollDirection: .vertical, names: ["dg_dengliang_1","dg_dengmie_1"], images: ["dg_dengliang_1","dg_dengmie_1"], viewIndex: 0);
        coll.backgroundColor = UIColor.clear;
        coll.center = CGPoint.init(x: view.bounds.width / 2, y: view.bounds.height/2);
        coll.selectCell = {
            (model: RectModel) in
            self.updateImage(value: model.name, viewIndex: 1);
        };
        
        view.addSubview(coll);
        self.backView!.contextView.addSubview(view);
        
    }
    //警示灯
    func createLightCautionOnOff() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let values = block!.getBlockValues();
        
        self.createTitleView(titles: ["端口","OUT2","RGB-LED警示","dg_jingche_1"], isEnables: [false,true,false,true], isLabels: [true,true,true,false]);
        
        let view = self.createWhiteBackView();
        
        let pading = AlertViewControl.replaceWidth(value: 60);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height/2 - 0.5*pading;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collWidth, height: collheight), type: block!.name, value: values[0])
        setPoint.center = CGPoint.init(x: self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);
        
        setPoint.callBack = {
            [weak self](value: String) in
            
            self!.update(value: value, viewIndex: 0);
        };
        self.backView!.contextView.addSubview(setPoint);
        
        view.frame.size = CGSize.init(width: collWidth, height: collheight);
        view.center = CGPoint.init(x: setPoint.center.x, y: setPoint.center.y*2.8);

        let coll = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading / 2, width: collWidth, height: collheight), cellWidth: collheight-20, scrollDirection: .vertical, names: ["dg_jingche_1","dg_jiuhuche_1"], images: ["dg_jingche_1","dg_jiuhuche_1"], viewIndex: 0);
        coll.backgroundColor = UIColor.clear;
        coll.center = CGPoint.init(x: view.bounds.width / 2, y: view.bounds.height/2);
        coll.selectCell = {
            (model: RectModel) in
            self.updateImage(value: model.name, viewIndex: 1);
        };
        
        view.addSubview(coll);
        self.backView!.contextView.addSubview(view);
    }
    
    //灯光颜色
    func createLightColor() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let values = block!.getBlockValues();
        
        self.createTitleView(titles: ["端口","OUT2","选色","gj_yanse_hong_1"], isEnables: [false,true,false,true,false], isLabels: [true,true,true,false]);
        
        let view = self.createWhiteBackView();
        
        let pading = AlertViewControl.replaceWidth(value: 60);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height/2 - pading*0.5;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collWidth, height: collheight), type: block!.name, value: values[0])
        setPoint.center = CGPoint.init(x: self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);
        
        setPoint.callBack = {
            [weak self](value: String) in
            
            self!.update(value: value, viewIndex: 0);
        };
        self.backView!.contextView.addSubview(setPoint);
        
        view.frame.size = CGSize.init(width: collWidth, height: collheight);
        view.center = CGPoint.init(x: setPoint.center.x, y: setPoint.center.y*2.8);
        
        let images = ["gj_yanse_bai_1","gj_yanse_hong_1","gj_yanse_lan_1","gj_yanse_cheng_1","gj_yanse_lv_1","gj_yanse_pin_1","gj_yanse_qing_1"];
        let colors = ["白","红","蓝","橙","绿","紫","青"];
        let coll = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading/2, width: collWidth, height: collheight), cellWidth: AlertViewControl.replaceWidth(value: 100), scrollDirection: .vertical, names: colors, images: images, viewIndex: 0);
        coll.selectCell = {
            (model: RectModel) in
            
            self.updateImage(value: model.image, viewIndex: 1);
        };
        coll.backgroundColor = UIColor.clear;
        coll.center = CGPoint.init(x: view.bounds.width/2, y: view.bounds.height/2);
        view.addSubview(coll);
        self.backView!.contextView.addSubview(view);
       
    }
    //高亮灯 亮度 highlight_level
    func createHighlightLevel() {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["端口","OUT2","高亮LED","%0"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        let values = self.block!.getBlockValues();
        
        let backView = self.createWhiteBackView();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 35);
        
        let slidWidth = backView.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading * 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: topPading, width: slidWidth, height: slidHeight), type: name, value: values[0]);
        setPoint.center.x = self.backView!.bounds.width/2;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        
        backView.frame = CGRect.init(x: leftPading, y: topPading*2 + slidHeight, width: backView.bounds.width, height: self.backView!.contextHeight/2-topPading);
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: slidWidth, height: slidHeight), hasGraduation: false, value: values[0]);
        slider.center.x = backView.bounds.width/2;
        slider.center.y = backView.bounds.height/2;
        slider.backgroundColor = UIColor.clear;
        
        backView.addSubview(slider);

        
        slider.callBack = {
            (value: Int) in
            
            let valueStr = String.init(format: "%d%%", value);
            self.update(value: valueStr, viewIndex: 1);
        };
        
        self.backView!.contextView.addSubview(backView);

    }
    
    //灯格颜色等级
    func createLight1() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["端口","OUT1","灯格","0级"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());
        
        let values = self.block!.getBlockValues();
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 60);
        
        let backView = self.createWhiteBackView();
        
        
        let slidWidth = self.backView!.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading*1.5;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: backView.bounds.width, height: slidHeight), type: name, value: values[0]);
        setPoint.center = CGPoint.init(x: self.backView!.bounds.width/2, y: self.backView!.contextHeight/4);
        
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        
        backView.frame.size.width = slidWidth;
        backView.frame.size.height = slidHeight;
        backView.center = CGPoint.init(x: setPoint.center.x, y: setPoint.center.y*2.8);
        var value: String = values[1];
        value = value.components(separatedBy: "级")[0];
        let live = NewLiveView.init(frame:  CGRect.init(x: 0,
                                                        y: 0,
                                                        width: slidWidth - leftPading * 2,
                                                        height: backView.bounds.height - topPading),
                                                        levelCount:5,
                                                        value:value);
        
        live.progressColor = block!.color;
        
        live.center = CGPoint.init(x: backView.bounds.width/2, y: backView.bounds.height/2);
        
        live.callBack = {
            (value: Int) in
            
            let valueStr = String.init(format: "%d级", value);
            
            self.update(value: valueStr, viewIndex: 1);
        };
        
        backView.addSubview(live);
        self.backView!.contextView.addSubview(backView);

    }
    
    //MARK: - 声音
    //daily_words
    
    func createDailyWords(title:String, values:[String]) {
        
        self.backView!.ABStyle = .noFootLong;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["端口","OUT1",title,values[0],"0.00","秒"], isEnables: [false,true,false,true,true,false], isLabels: [true,true,true,true,true,true]);
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let bvalues = self.block!.getBlockValues();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 60);
        
        
        
        let view = self.createWhiteBackView();
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: leftPading, y: topPading/2, width: view.bounds.width, height: view.bounds.height/3), type: block!.name, value: bvalues[0]);
        setPoint.callBack = {
            [weak self](value: String) in
            self!.update(value: value, viewIndex: 0);
            
        };
        self.backView!.contextView.addSubview(setPoint);
        
        view.frame.size.height = self.backView!.contextHeight/3*2 - topPading;
        view.frame.size.width = view.frame.width/2 ;
        view.center = CGPoint.init(x: self.backView!.bounds.width/4, y: self.backView!.contextHeight/3*2);
        view.frame.origin.x = leftPading;
        self.backView!.contextView.addSubview(view);
        
        
        let pading = AlertViewControl.replaceWidth(value: 30);
        
        let collWidth = view.bounds.width - pading*2;
        let collheight = view.bounds.height - pading * 2;
        
        let names = values;

        let table = self.createTableView(frame: CGRect.init(x: pading, y: pading, width: collWidth, height: collheight), names: names, cellHeight: collheight/4);

        table.backgroundColor = UIColor.clear;
        
        table.callBack = {
            (model: RectModel) in
            
            self.update(value: model.name, viewIndex: 1);
        }
        
        view.addSubview(table);
        
        let dateView = DataPickerControl.init(frame: CGRect.init(x: table.frame.origin.x + pading + table.frame.size.width, y: pading, width: collWidth, height: collheight/2), value: bvalues.last!);
        dateView.SStyle = .centisecond;
        dateView.center = CGPoint.init(x: self.backView!.contextView.bounds.width/4*3, y: self.backView!.contextHeight/3*2);
        dateView.callBack = {
            (value: String) in
            
            self.update(value: value, viewIndex: 2);
        }
        
        self.backView!.contextView.addSubview(view);
        self.backView!.contextView.addSubview(dateView);
        
    }
    
    //动作
    func createAction() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        let iWidth = titleHeight/5.0*4;
        var views: [UIView] = Array();
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "动作";
        views.append(label1);
               
        let imageView = self.returmImageView(width: iWidth, image: "dg_jiuhuche_1");
        self.setRuntime(value: "dg_jiuhuche_1", objct: imageView);
        views.append(imageView);
        self.addTitleLayoutWith(views: views);
        
        let view = self.createWhiteBackView();
        
        self.backView!.contextView.addSubview(view);
        
        
        let pading = AlertViewControl.replaceWidth(value: 30);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height - pading * 2;
        let cellWight = AlertViewControl.replaceWidth(value: 110);
        
        let names: [String] = ["dg_jiuhuche_1","dg_jiuhuche_1","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche","dg_jiuhuche",];
        
        let collView = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading, width: collWidth, height: collheight), cellWidth: cellWight, scrollDirection: .vertical, names: names, images: names, viewIndex: 0);
        collView.backgroundColor = UIColor.clear;
        collView.selectCell = {
            (model: RectModel) in
            
            self.updateImage(value: model.image, viewIndex: 0);
        };
        
        view.addSubview(collView);
    }
    
    //动物声音
    func createAnimalSound() {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        let iWidth = titleHeight/5.0*4;
        var views: [UIView] = Array();
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "动物";
        views.append(label1);
        
        let imageView = self.returmImageView(width: iWidth, image: "gj_sy_mao");
        self.setRuntime(value: "gj_sy_mao", objct: imageView);
        views.append(imageView);
        self.addTitleLayoutWith(views: views);
        
        let view = self.createWhiteBackView();
        
        self.backView!.contextView.addSubview(view);
        
        
        let pading = AlertViewControl.replaceWidth(value: 30);
        
        let collWidth = view.bounds.width - pading * 2;
        let cellWight = AlertViewControl.replaceWidth(value: 110);
        
        let names: [String] = ["gj_sy_mao","gj_sy_gou","gj_sy_konglong","gj_sy_niao"];
        
        let collView = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading, width: collWidth, height: cellWight+20), cellWidth: cellWight, scrollDirection: .vertical, names: names, images: names, viewIndex: 0);
        collView.center.y = view.bounds.height/2;
        collView.backgroundColor = UIColor.clear;
        collView.selectCell = {
            (model: RectModel) in
            
            self.updateImage(value: model.image, viewIndex: 0);
        };
        
        view.addSubview(collView);

        
    }
    
    //交通工具
    func createTransportSound() {
        
        self.backView!.ABStyle = .noFoot;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        let iWidth = titleHeight/5.0*4;
        var views: [UIView] = Array();
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = "交通工具";
        views.append(label1);
        
        let imageView = self.returmImageView(width: iWidth, image: "gj_sy_che");
        self.setRuntime(value: "gj_sy_che", objct: imageView);
        views.append(imageView);
        self.addTitleLayoutWith(views: views);
        
        let view = self.createWhiteBackView();
        
        self.backView!.contextView.addSubview(view);
        
        
        let pading = AlertViewControl.replaceWidth(value: 30);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height - pading * 2;
        let cellWight = AlertViewControl.replaceWidth(value: 160);
        
        let names: [String] = ["gj_sy_che","gj_sy_lunchuan","gj_sy_huoche","gj_sy_feiji","gj_sy_xiaofangche","gj_sy_jiuhuche","gj_sy_jingche"];
        
        let collView = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading, width: collWidth, height: collheight), cellWidth: cellWight, scrollDirection: .vertical, names: names, images: names, viewIndex: 0);
        collView.center.y = view.bounds.height/2;
        collView.backgroundColor = UIColor.clear;
        collView.selectCell = {
            (model: RectModel) in
            
            self.updateImage(value: model.image, viewIndex: 0);
        };
        
        view.addSubview(collView);

    }
    
    //开关弹窗
    func createOnOffView(names: [String], title:String) {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
       
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        let iWidth = titleHeight/5.0*3.0 + 8;
        var views: [UIView] = Array();
        let label1 = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        label1.text = title;
        views.append(label1);
        let imageView = self.returmImageView(width: iWidth, image: names[0]);
        self.setRuntime(value: names[0], objct: imageView);
        views.append(imageView);
        
        self.addTitleLayoutWith(views: views);
        
        let view = self.createWhiteBackView();
        
        let pading = AlertViewControl.replaceWidth(value: 60);
        
        let collWidth = view.bounds.width - pading * 2;
        let collheight = view.bounds.height - pading;
        
        let coll = self.createTwoButtom(frame: CGRect.init(x: pading, y: pading / 2, width: collWidth, height: collheight), cellWidth: collheight-20, scrollDirection: .vertical, names: names, images: names, viewIndex: 0);
        coll.backgroundColor = UIColor.clear;
        coll.selectCell = {
            (model: RectModel) in
            self.updateImage(value: model.name, viewIndex: 0);
        };
        
        view.addSubview(coll);
        self.backView!.contextView.addSubview(view);
    }
    
    //BuzzerLevel
    func createBuzzerLevel() {
        
        self.backView!.ABStyle = .noFootLong;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let resize = AlertViewControl.resize(size: CGSize.init(width: 40, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
        
        self.createTitleView(titles: ["端口","OUT1","蜂鸣器","do","0秒"], isEnables: [false,true,false,true,true], isLabels: [true,true,true,true,true]);
        
        let values = self.block!.getBlockValues();
        let backViewWidth = self.backView!.contextView.bounds.width - leftPading * 2;
        let backViewHeight = (self.backView!.contextHeight - topPading * 3)/3;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: leftPading, y: topPading, width: backViewWidth, height: backViewHeight), type: block!.name, value: values[0]);
        
        setPoint.callBack = {
            [weak self](value: String) in
            
            self?.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        let soundView = SoundView.init(frame: CGRect.init(x: leftPading, y: topPading+backViewHeight, width: backViewWidth, height: backViewHeight*1.5), level: values[1])
        
        soundView.callBack = {
            (value: String) in
            
            self.update(value: value, viewIndex: 1);
        };
        
        self.backView!.contextView.addSubview(soundView);
        
        
        let time:String = values[2].components(separatedBy: "秒").first!;
        let step = NewStepper.init(frame: CGRect.init(x: 0, y: 0, width: backViewWidth/2, height: backViewHeight/3), value:time);
        
        step.center = CGPoint.init(x: soundView.center.x, y: soundView.center.y + backViewHeight*1.2);
        step.min = 0;
        step.max = 60;
        step.callBack = {
            (value: Int) in
            
            let str = String.init(format: "%d秒", value);
            self.update(value: str, viewIndex: 2);
        };
        
        self.backView!.contextView.addSubview(step);

    }
    
    //MARK: - 端口
    
    ///设置端口开关
    func createPortOnOff() {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["设置端口","OUT1","开"], isEnables: [false,true,true], isLabels: [true,true,true]);
        
        let values = self.block!.getBlockValues();
        
        let backView = self.createWhiteBackView();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 35);
        
        let slidWidth = backView.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading * 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: topPading, width: slidWidth, height: slidHeight), type: name, value: values[0]);
        setPoint.center.x = self.backView!.bounds.width/2;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        
        backView.frame = CGRect.init(x: 0, y: topPading*2 + slidHeight, width: AlertViewControl.replaceWidth(value: 260), height: self.backView!.contextHeight/2-topPading);
        backView.center.x = setPoint.center.x;
        let sswitch = NewSwitch.init(frame: CGRect.init(x: 0, y: 0, width: AlertViewControl.replaceWidth(value: 200), height: AlertViewControl.replaceWidth(value: 100)));
        sswitch.onTitle = "开";
        sswitch.offTitle = "关";
        sswitch.onImage = "kai";
        sswitch.offImage = "guan";
        sswitch.currentTitle = values[1];
        sswitch.callback = {
            [weak self] (value: Int) in
            
            let string = value == 1 ? "开" : "关";
            self!.update(value: string, viewIndex: 1);
        };
        
        sswitch.center.x = backView.bounds.width/2;
        sswitch.center.y = backView.bounds.height/2;
        
        sswitch.backgroundColor = UIColor.clear;
        
        backView.addSubview(sswitch);
        
        
        self.backView!.contextView.addSubview(backView);
        
    }
    
    ///设置端口输出类型
    func createPortType() {
        
        let values = block!.getBlockValues();
        self.backView!.ABStyle = .noFoot;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let resize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
                
        self.createTitleView(titles: ["设置端口","OUT2","数字"], isEnables: [false,true,true], isLabels: [true,true,true]);
        
        let backViewWidth = self.backView!.contextView.bounds.width - leftPading * 2;
        let backViewHeight = self.backView!.contextHeight - topPading * 3;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: leftPading, y: topPading, width: backViewWidth, height: backViewHeight/2), type: name, value: values[0]);
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        let setPoint1 = SetPointView.init(frame: CGRect.init(x: leftPading, y: backViewHeight/2 + topPading*2, width: backViewWidth, height: backViewHeight/2), type: "out_type", value: values[1]);
        
        setPoint1.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 1);
        };
        
        
        self.backView!.contextView.addSubview(setPoint);
        self.backView!.contextView.addSubview(setPoint1);
    }
    
    ///设置端口值大于某值
    func createPortIn()  {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["当端口","IN1","值大于","0"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        let values = self.block!.getBlockValues();
        
        let backView = self.createWhiteBackView();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 35);
        
        let slidWidth = backView.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading * 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: topPading, width: slidWidth, height: slidHeight), type: name, value: values[0]);
        setPoint.center.x = self.backView!.bounds.width/2;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        let valueInt:Float = NSString.init(string: values[1]).floatValue/255.0 * 100;
        
        let initValue = String.init(format: "%d",Int(valueInt));
        backView.frame = CGRect.init(x: leftPading, y: topPading*2 + slidHeight, width: backView.bounds.width, height: self.backView!.contextHeight/2-topPading);
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: slidWidth, height: slidHeight), hasGraduation: false, value: initValue);
        slider.center.x = backView.bounds.width/2;
        slider.center.y = backView.bounds.height/2;
        slider.backgroundColor = UIColor.clear;
        
        backView.addSubview(slider);
        
        slider.floatCallback = {
            [weak self](vlaue: CGFloat) in
            
            let newValue:CGFloat = vlaue/100*255;
            self!.update(value: String.init(format: "%d", Int(newValue)), viewIndex: 1);
        };
        
        self.backView!.contextView.addSubview(backView);
        
    }
    ///设置端口输出
    func createPortOut() {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["设置端口","OUT1","输出","0"], isEnables: [false,true,false,true], isLabels: [true,true,true,true]);
        
        let values = self.block!.getBlockValues();
        
        let backView = self.createWhiteBackView();
        
        let leftPading = AlertViewControl.replaceWidth(value: 30);
        let topPading = AlertViewControl.replaceWidth(value: 35);
        
        let slidWidth = backView.bounds.width - leftPading * 2;
        let slidHeight = self.backView!.contextHeight/2 - topPading * 2;
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: topPading, width: slidWidth, height: slidHeight), type: name, value: values[0]);
        setPoint.center.x = self.backView!.bounds.width/2;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(setPoint);
        
        backView.frame = CGRect.init(x: leftPading, y: topPading*2 + slidHeight, width: backView.bounds.width, height: self.backView!.contextHeight/2-topPading);
        let slider = NewSlider.init(frame: CGRect.init(x: 0, y: 0, width: slidWidth, height: slidHeight), hasGraduation: false, value: values[1]);
        slider.center.x = backView.bounds.width/2;
        slider.center.y = backView.bounds.height/2;
        slider.backgroundColor = UIColor.clear;
        
        backView.addSubview(slider);
        
        slider.floatCallback = {
            [weak self](vlaue: CGFloat) in
            
            self!.update(value: String.init(format: "%d", Int(vlaue)), viewIndex: 1);
        };
        
        self.backView!.contextView.addSubview(backView);
    }
    //MARK: - 控制
    func createFuncation() {
        
        self.backView!.ABStyle = .noFootShout;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let titleHeight = self.backView!.titleHeight / 2;
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);

        
        self.createTitleView(titles: ["函数",""], isEnables: [false, true], isLabels: [true, true]);
        
        let view = self.createFunctionNameView(font: font, title: "命名函数");
        
        view.center = CGPoint.init(x: view.center.x, y: view.center.y);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(noti:)), name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHiden), name: .UIKeyboardWillHide, object: nil);
        
        self.backView!.contextView.addSubview(view);

        
    }
    
    func createDoFunction() {
        
        self.backView!.ABStyle = .noFootShout;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
//        let titleHeight = self.backView!.titleHeight / 2;
        
        
        self.createTitleView(titles: ["调用",""], isEnables: [false, true], isLabels: [true, true]);
        
        let view = DoFunctionCollection.init(frame: self.backView!.contextView.bounds);
        view.datas = Array(FunctionControl.functionControl.names.values);
        
        view.callback = {
        
            (name: String) in
            
            self.update(value: name, viewIndex: 0);
        };
        self.backView!.contextView.addSubview(view);
    }
    
    ///两边变量的if repat
    func createTwoAlert(title:String) {
        
        self.currentIndex = 0;
        self.backView!.ABStyle = .noFoot;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        let resize = AlertViewControl.resize(size: CGSize.init(width: 40, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
    
        self.createTitleView(titles: [title, "按钮被触碰", "or", "按钮被触碰"], isEnables: [false, true, true, true], isLabels: [true, true, true, true]);
       
        for view in imputViews {
            view.isUserInteractionEnabled = true;
        }
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());
        
        let values = self.block!.getBlockValues();
        
        let height = self.backView!.bounds.height - 3*topPading;
        let wdth = self.backView!.contextView.bounds.width - 2 * leftPading;
        let cennHeight = AlertViewControl.replaceWidth(value: 110);
        
        
        let images = ["kaishi_anniu_zhong2","kaishi_yanse6","kaishi_yousheng7","kaishi_hongwai_11","gj_youyali","kaishi_liangdu16"];
        
        let names = ["按钮被触碰","颜色","听到声音","红外线","有压力","亮度"];
        var dataArray: [RectModel] = Array();
        for i in 0 ..< images.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            dataArray.append(model);
        }
        let first = RectCollectionView.init(frame: CGRect.init(x: leftPading, y: topPading, width: wdth, height: height/3), cellWidth: cennHeight, scrollDirection: .vertical, value:values[self.currentIndex!]);
        first.modelArray = dataArray;
        //
        let view = SetPointView.init(frame: CGRect.init(x: leftPading, y: height/2, width: wdth, height: height/3), type: "while", value: values[self.currentIndex!]);
        view.isHidden = true;
        view.callBack = {
            [weak self](value:String) in
            
            self!.currentPort = value;
            self!.updateWhileValue(index: (self!.currentIndex)!);
        };
        
        self.backView!.contextView.addSubview(view);

        //
        first.selectCell = {
            [weak self](model: RectModel) in
            
            if model.name != "按钮被触碰" {
                
                self!.backView!.ABStyle = .noFoot;
                view.isHidden = false;
                
                if view.currentTitle != nil {
                    self!.currentPort = view.currentTitle!.titleLabel!.text!;
                    
                } else {
                    self!.currentPort = "IN1";
                }
                
            } else {
                
                self!.backView!.ABStyle = .noFootShout;
                view.isHidden = true;
                self!.currentPort = "无";
            }
            
            self!.models.removeAll();
            self!.models.append(model);
            if values.first!.contains("%") && model.name == "亮度" {
                
                var lightValue = values.first!.components(separatedBy: "%").first!;
                lightValue = lightValue.components(separatedBy: "亮度").last!;
                model.value = lightValue;
            }
            self!.backView!.contextView.setNeedsLayout();
            self!.backView!.contextView.layoutIfNeeded();
            self?.updateTitle(model: model, index: self!.currentIndex!);
        };
        
        self.getWhileAttStringWith(value: values[0],index: 0);
        self.getWhileAttStringWith(value: values[2], index: 2);
        
        dataArray = Array();
        for i in 0 ..< images.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            dataArray.append(model);
        }
        self.backView!.contextView.addSubview(first);
    
    }
    
//MARK: - 时间菜单
    
  ///  通过滑轮调整等到时间
    func createLongTime() {
        
        self.backView!.ABStyle = .noFootShout;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["等待", "0", "分", "0.00", "秒"], isEnables: [false, true, false, true, false], isLabels: [true, true, true, true, true]);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let resize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
        
        let backView = self.createWhiteBackView();
        backView.backgroundColor = UIColor.clear;
        self.backView!.contextView.addSubview(backView);
        
        let width = (self.backView!.bounds.width - leftPading * 2) / 9;
        var height = self.backView!.contextHeight - topPading * 3;
        let newTopPading = topPading / 2;
        height = height - 2 * newTopPading;
        
        let whiteView = WhiteBlackView.init(frame: CGRect.init(x: 0, y: newTopPading, width: width*2, height: height));
        
        let values = self.block!.getBlockValues();
        
        let mview = DatePickerView.init(frame: whiteView.bounds, value: values.first!);
        let mdata: [String] = {
            var array: [String] = Array();
            
            for i in 0 ..< 60 {
                
                let str = String.init(format: "%d", i);
                array.append(str);
            }
            
            return array;
        }();
        mview.dataArray = mdata;
        mview.callback = {
            [weak self](str : String) in
            self?.update(value: str, viewIndex: 0);
        };
        whiteView.addSubview(mview);
        backView.addSubview(whiteView);
        
        let label = UILabel.init(frame: CGRect.init(x: width*2.4, y: newTopPading, width: width*2-0.2*width, height: height));
        label.font = UIFont.systemFont(ofSize: width/2);
        label.text = "分钟";
        label.textColor = UIColor.white;
        backView.addSubview(label);
        
        let sView = DataPickerControl.init(frame: CGRect.init(x: width*4, y: newTopPading, width: width*4, height: height), value: values.last!);
        sView.SStyle = .centisecond;
        
        sView.callBack = {
            [weak self](value: String) in
            
            self?.update(value: value, viewIndex: 1);
        }
        backView.addSubview(sView);
        
        let lab = UILabel.init(frame: CGRect.init(x: 8*width + 0.1*width, y: newTopPading, width: width*0.9, height: height));
        lab.font = UIFont.systemFont(ofSize: width/2);
        lab.text = "秒";
        lab.textColor = UIColor.white;
        backView.addSubview(lab);
    }
    ///随机等待
    func createRandomTime(title:String, uinit:String) {
        
        self.backView!.ABStyle = .noFootShout;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        
        self.createTitleView(titles: [title, "1", uinit], isEnables: [false, true, false], isLabels: [true, true, true]);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let view = self.createWhiteBackView();
        view.backgroundColor = UIColor.clear;
        let values = self.block!.getBlockValues();
        
        let steep = NewStepper.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width / 2, height: view.bounds.height/3*2),value:values.first!);
        
        steep.center = CGPoint.init(x: view.bounds.width/2, y: view.bounds.height/2);
        steep.callBack = {
            (value: Int) in
           self.update(value: String.init(format: "%d", value), viewIndex: 0);
        }
        view.addSubview(steep);
        
        self.backView!.contextView.addSubview(view);
    }
    
    ///等待端口打开或者开放
    func createWaitPortOpen() {
        
        
    }
    
    ///设置计时器单位
    func createSetTimerUnit() {
        
        let values = block!.getBlockValues();
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        
        self.createTitleView(titles: ["设置计时器单位","s"], isEnables: [false,true], isLabels: [true,true]);
        
        let height = self.backView!.contextHeight / 2;
        
        let collecWidth = self.backView!.bounds.width / 5 * 4;
        
        let centerX = self.backView!.bounds.width / 2;
        
        
        let setPoint = SetPointView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), datas:["s","ms"], value:values[0]);
        setPoint.center.x = centerX;
        setPoint.callBack = {
            [weak self] (value: String) in
            self!.update(value: value, viewIndex: 0);
        };
        setPoint.center = CGPoint.init(x: centerX, y: self.backView!.contextHeight/2);
        
        self.backView!.contextView.addSubview(setPoint);

        
    }
    
    //MARK: - 数学计算
    ///设置变量等于数学计算
    func createMathOperator() {
        
        
    }
    ///判断奇数
    func createMathEvent() {
        
        
    }
    ///变量取整
    func createMathInteger() {
        
        
    }
    ///将端口输出值按比例转换
    func createMathTrans() {
        
    }
    ///将变量设置为范围值
    func createMathRandom() {
        
        
    }
    
//MARK: - 变量弹窗
    ///设置变量
    func createSetValue() {
        
        self.backView!.ABStyle = .noFootLong;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["设置","bl_yuan","=","0"], isEnables: [false,true,false,true], isLabels: [true,false,true,true]);
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        
        let value = block!.getBlockValues()[1];
        
        if value.contains(",") {
            
            let array = value.components(separatedBy:",");
            
            if array[0] != "" {
                
                self.update(value: array[0], viewIndex: 1);
                
            } else if array[1] != "" {
            
                self.models.removeAll();
                let model = RectModel.init();
                model.name = "bianliang";
                model.value = array[1];
                self.models.removeAll();
                self.models.append(model);
                self.updateWhileValue(index: 1);

            }
        }
        
        let view = self.createWhiteBackView();
        
        view.backgroundColor = UIColor.clear;
        
        self.backView!.contextView.addSubview(view);
        
        let width = view.bounds.width / 7;
        let height = view.bounds.height;
        
//        bl_sanjiao_2":"0021",
//        "bl_xingxing_2":"0010",
//        "bl_yuan_2":"0011",
//        "bl_fang_2":"0012
        
        let con = self.createTwoButtom(frame: CGRect.init(x: 0, y: 0, width: width, height: height), cellWidth: width-20, scrollDirection: .horizontal, names: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], images: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], viewIndex: 0);

        con.selectCell = {
            [weak self](model: RectModel) in
            
            self?.updateImage(value: model.name, viewIndex: 0);
        };
        
        view.addSubview(con);
        
        let bundel = Bundle(identifier: "com.google.blockly.Blockly");
        let checkView: CheckBackView = bundel!.loadNibNamed("CheckBackView", owner: self, options: nil)?.last as! CheckBackView
        checkView.frame = CGRect.init(x: width*1.5, y: 0, width: width*4, height: height);
        checkView.heads = ["shuzi","bianliang","chuangan","suiji"];
        checkView.callback = {
            [weak self](str: String) in
            
            self?.models.removeAll();
            let model = RectModel.init();
            if str.contains("bl") {
                
                
                model.name = "bianliang";
                model.value = str;
                
            } else {
                
                model.name = str;
            }
            self?.models.append(model);
            self?.updateWhileValue(index: 1);
        };
        
        view.addSubview(checkView);
        
    }
    
    ///重复变量次
    func createVariableRepetitionNum() {
        
        self.backView!.ABStyle = .noFootShout;
        
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();

        self.createTitleView(titles: ["重复","bl_yuan","次"], isEnables: [false,true,false], isLabels: [true, false,true]);
        
        
        let height = self.backView!.contextHeight / 2;
        
        let collecWidth = self.backView!.bounds.width / 5 * 4;
        
        let centerX = self.backView!.bounds.width / 2;
        
        let ABCView = RectCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: collecWidth, height: height), cellWidth: height - 20, scrollDirection: .vertical, value: block!.getBlockValues().first!);
        let names = ["园","方","三角","星"];
        let images = ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"];
        
        var data: [RectModel] = Array();
        for i in 0 ..< names.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            
            data.append(model);
        }
        
        ABCView.modelArray = data;
        ABCView.center = CGPoint.init(x: centerX, y: self.backView!.contextHeight/2);
        ABCView.cellBorderColor = self.backColor;
        ABCView.selectCell = {
            [weak self](model: RectModel) in
            
            self?.updateImage(value: model.image, viewIndex: 0);
        };
        
        self.backView!.contextView.addSubview(ABCView);
    }
    
    ///用。。。改变
    func createUseChange() {
        
        self.backView!.ABStyle = .noFootLong;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: ["用","+","1","改变","bl_yuan"], isEnables: [false,true,true,false,true], isLabels: [true,true,true,true,false]);
        
        self.updataTitleWithValues(values: self.block!.getBlockValues());

        let value = block!.getBlockValues()[1];
        
        if value.contains(",") {
            
            let array = value.components(separatedBy:",");
            
            if array[0] != "" {
                
                self.update(value: array[0], viewIndex: 1);
                
            } else if array[1] != "" {
                
                self.models.removeAll();
                let model = RectModel.init();
                model.name = "bianliang";
                model.value = array[1];
                self.models.removeAll();
                self.models.append(model);
                self.updateWhileValue(index: 1);
                
            }
        }
        
        let view = self.createWhiteBackView();
        
        view.backgroundColor = UIColor.clear;
        
        self.backView!.contextView.addSubview(view);
        
        let width = view.bounds.width / 7;
        let height = view.bounds.height;
        
        //        bl_sanjiao_2":"0021",
        //        "bl_xingxing_2":"0010",
        //        "bl_yuan_2":"0011",
        //        "bl_fang_2":"0012
        
        let con1 = self.createTwoButtom(frame: CGRect.init(x: 0, y: 0, width: width, height: height), cellWidth: width-20, scrollDirection: .horizontal, names: ["+","-","x","÷"], images: ["gj_jia_1","gj_jian_1","gj_cheng_1","gj_chu_1"], viewIndex: 0);
        
        con1.selectCell = {
            [weak self] (model: RectModel) in
            
            self?.update(value: model.name, viewIndex: 0);
        };
        view.addSubview(con1);
        let con = self.createTwoButtom(frame: CGRect.init(x: view.bounds.width-width, y: 0, width: width, height: height), cellWidth: width-20, scrollDirection: .horizontal, names: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], images: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], viewIndex: 0);
        con.selectCell = {
            [weak self](model: RectModel) in
            
            self?.updateImage(value: model.name, viewIndex: 2);
        };
        
        view.addSubview(con);
        
        let bundel = Bundle(identifier: "com.google.blockly.Blockly");
        let checkView: CheckBackView = bundel!.loadNibNamed("CheckBackView", owner: self, options: nil)?.last as! CheckBackView
        checkView.frame = CGRect.init(x: width*1.5, y: 0, width: width*4, height: height);
        checkView.heads = ["shuzi","bianliang","chuangan","suiji"];
        checkView.callback = {
            [weak self](str: String) in
            
            self?.models.removeAll();
            let model = RectModel.init();
            if str.contains("bl") {
                
                
                model.name = "bianliang";
                model.value = str;
                
            } else {
                
                model.name = str;
            }
            self?.models.append(model);
            self?.updateWhileValue(index: 1);
        };
        
        view.addSubview(checkView);
        

    }
    
    ///变量判断
    func createVariableIf(title: String) {
        
        self.backView!.ABStyle = .noFootLong;
        self.backView!.contextView.setNeedsLayout();
        self.backView!.contextView.layoutIfNeeded();
        
        self.createTitleView(titles: [title,"bl_yuan",">","0"], isEnables: [false,true,true,true], isLabels: [true,false,true,true]);
        
        let view = self.createWhiteBackView();
        
        view.backgroundColor = UIColor.clear;
        
        self.backView!.contextView.addSubview(view);
        
        let width = view.bounds.width / 7;
        let height = view.bounds.height;
        
        //        bl_sanjiao":"0021",
        //        "bl_xingxing":"0010",
        //        "bl_yuan":"0011",
        //        "bl_fang":"0012
        
        let con = self.createTwoButtom(frame: CGRect.init(x: 0, y: 0, width: width, height: height), cellWidth: width-20, scrollDirection: .horizontal, names: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], images: ["bl_yuan_1","bl_fang_1","bl_sanjiao_1","bl_xingxing_1"], viewIndex: 0);
        
        con.selectCell = {
            [weak self](model: RectModel) in
            
            self?.updateImage(value: model.name, viewIndex: 0);
        };
        
        view.addSubview(con);
        
        let con1 = self.createTwoButtom(frame: CGRect.init(x: 1.5*width, y: 0, width: width, height: height), cellWidth: width-20, scrollDirection: .horizontal, names: [">","<","=","≠"], images: ["gj_dayu","gj_xiaoyu","gj_dengyu","gj_budengyu"], viewIndex: 1);
        
        con1.selectCell = {
            [weak self] (model: RectModel) in
            
            self?.update(value: model.name, viewIndex: 1);
        };
        view.addSubview(con1);
        
        let bundel = Bundle(identifier: "com.google.blockly.Blockly");
        let checkView: CheckBackView = bundel!.loadNibNamed("CheckBackView", owner: self, options: nil)?.last as! CheckBackView
        checkView.frame = CGRect.init(x: width*3, y: 0, width: width*4, height: height);
        checkView.heads = ["shuzi","bianliang","chuangan","suiji"];
        checkView.callback = {
            [weak self](str: String) in
            
            self?.models.removeAll();
            let model = RectModel.init();
            if str.contains("bl") {
                
                
                model.name = "bianliang";
                model.value = str;
                
            } else {
                
                model.name = str;
            }
            self?.models.append(model);
            self?.updateWhileValue(index: 2);
        };
        
        view.addSubview(checkView);

        
    }
    
   ///白色圆框背景
    func createWhiteBackView() -> WhiteBlackView {
        let resize = AlertViewControl.resize(size: CGSize.init(width: 30, height: 60));
        let leftPading = resize.width;
        let topPading = resize.height;
        let backViewWidth = self.backView!.contextView.bounds.width - leftPading * 2;
        let backViewHeight = self.backView!.contextHeight - topPading * 2;
        
        let view = WhiteBlackView.init(frame: CGRect.init(x: leftPading, y: topPading, width: backViewWidth, height: backViewHeight));
        
        return view;

    }
     ///电机的四个按钮
    func createFourButtom(frame: CGRect, cellWidth:CGFloat, scrollDirection: UICollectionViewScrollDirection, viewIndex: Int) -> RectCollectionView {
        
        let ABCView = RectCollectionView.init(frame: frame, cellWidth: cellWidth, scrollDirection: scrollDirection, value:"A");
        let names = ["A","B","C","D"];
        let images = ["machine_A","machine_B","machine_C","machine_D"];
        
        var data: [RectModel] = Array();
        for i in 0 ..< names.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            
            data.append(model);
        }
        
        ABCView.modelArray = data;
        ABCView.cellBorderColor = self.backColor;
        ABCView.selectCell = {
            (model: RectModel) in
            
            self.update(value: model.name, viewIndex: viewIndex);
        };
        return ABCView;
    }
    
    func createTwoButtom(frame: CGRect, cellWidth:CGFloat, scrollDirection: UICollectionViewScrollDirection, names: [String], images: [String], viewIndex: Int) -> RectCollectionView {
        
        let ABCView = RectCollectionView.init(frame: frame, cellWidth: cellWidth, scrollDirection: scrollDirection, value:block!.getBlockValues()[viewIndex]);
        var data: [RectModel] = Array();
        for i in 0 ..< names.count {
            
            let model = RectModel.init();
            model.name = names[i];
            model.image = images[i];
            
            data.append(model);
        }
        
        ABCView.modelArray = data;
        ABCView.cellBorderColor = self.backColor;
        ABCView.selectCell = {
           [weak self] (model: RectModel) in
            
            self!.update(value: model.name, viewIndex: viewIndex);
        };
        return ABCView;
    }

    //创建titleView
    func createTitleView(titles:[String], isEnables:[Bool], isLabels:[Bool]) {
        
        let titleHeight = self.backView!.titleHeight / 2;
        
        let font = UIFont.systemFont(ofSize: titleHeight / 4 * 3);
        
        var views: [UIView] = Array();
        
        
        for i in 0 ..< titles.count {
         
            let title = titles[i];
            let isEnable = isEnables[i];
            let isLabel = isLabels[i];
            
            if isLabel {
                
                let color = isEnable ? UIColor.black : UIColor.white;
                let label = self.returnLabel(textColor: color, font: font, isChange: isEnable);
                label.text = title;
                
                if isEnable {
                    self.setRuntime(value: label.text!, objct: label);
                }
                
                views.append(label);
                
            } else {
                
                let iWidth = titleHeight/5.0*3.0 + 8;
                
                let imageView = self.returmImageView(width: iWidth, image: title);
                if isEnable {
                    
                     self.setRuntime(value: title, objct: imageView);
                }
               
                views.append(imageView);
            }
        }
        
        
        self.addTitleLayoutWith(views: views);

    
        
    }
    
    //创建tableview
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
    
    //创建输入框弹窗
    func createFunctionNameView(font:UIFont, title:String) -> UIView {
        let whiteView = self.createWhiteBackView();
        whiteView.backgroundColor = UIColor.clear;
        let height = whiteView.bounds.height/3;
        let titleLabel = self.returnLabel(textColor: UIColor.white, font: font, isChange: false);
        titleLabel.text = title;
        titleLabel.textAlignment = .center;
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: whiteView.bounds.width, height: height);
        whiteView.addSubview(titleLabel);
        
        let backView = WhiteBlackView.init(frame: CGRect.init(x: 0, y: height, width: whiteView.bounds.size.width/3*2, height: height*2));
        backView.center = CGPoint.init(x: whiteView.bounds.width/2, y: backView.center.y);
        
        whiteView.addSubview(backView);
        
        let textField = UITextField.init(frame: CGRect.init(x: 20, y: 10, width: backView.bounds.width-40, height: height*2-20));
        textField.font = font;
        textField.autocapitalizationType = .none;
        textField.placeholder = "请输入函数名";
        textField.delegate = self;
        backView.addSubview(textField);
        
        
        return whiteView;
    }
    
    //根据imputViews的index（顺序显示） 更新value
    func update(value: String, viewIndex: Int) {
        
        let label = self.imputViews[viewIndex] as! UILabel;
        
        label.text = value;
        
        self.setRuntime(value: label.text!, objct: label);
    }
    
    func updateImage(value: String, viewIndex: Int) {
        
        let image = self.imputViews[viewIndex] as! UIImageView;
        
        image.image = UIImage.init(named: value);
        
        self.setRuntime(value: value, objct: image);
    
    }
}

extension AlertViewControl : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        var str = textField.text!;
        
        if string == "," {
            
            return false;
        }
        
        if (str.characters.count == 0) {
            
            str.append(string);
        } else {
            
            str.replaceSubrange(str.range(from: range)!, with: string);
        }
        
        let label = self.imputViews[0] as! UILabel;
        label.text = str;
        self.update(value: label.text!, viewIndex: 0);
        return true;
    }
    
    func keybordWillShow(noti:NSNotification) {
        
        let kbInfo = noti.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.2) { 
            
            self.frame.origin.y = 0 - kbRect.size.height/3;
        }
    }
    func keybordWillHiden() {
        
        
        UIView.animate(withDuration: 0.2) {
            
            self.frame.origin.y = 0;
        }

        
    }
    
    ///更新弹窗显示
    func updataTitleWithValues(values: [String]) {
        
        
        for i in 0 ..< values.count {
            
            let view = self.imputViews[i];
            let value = values[i];

            if (view.isMember(of: NewLabel.self)) {
                
                
                self.update(value: value, viewIndex: i);
                
                
            } else {
                
                if value.contains("|") {
                    
                    let str = value.components(separatedBy: "|").last;
                    NSLog("%@", str!);
                    self.updateImage(value: str!, viewIndex: i);

                } else {
                    self.updateImage(value: value, viewIndex: i);

                }
//                let image = view as! UIImageView;
//                image.image = UIImage.init(named: values[i]);
            }
        }
        
    }
    
}


//NSRange转化为range
extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

