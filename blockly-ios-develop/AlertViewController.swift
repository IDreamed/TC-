//
//  AlertViewController.swift
//  Pods
//
//  Created by 张 on 2017/5/23.
//
//

import UIKit

typealias HidAlertCallBack = (_ strings: [String]) -> Void

struct runtimeKey {
    
    static var alertKey = "alertKey"
    
}

class AlertViewControl: UIView {

    public enum alertBackStyle {
        
        case defaultStyle,
        noFoot,
        noFootLong,
        noFootShout
    }
    
    //为两个的if repeat添加辅助
    var currentIndex: Int? {
        didSet {
            if oldValue == currentIndex {
                
                return ;
            }
            if imputViews.count > 0 {
                
                let label = imputViews[currentIndex!] as! UILabel;
                
                let text = objc_getAssociatedObject(label, &runtimeKey.alertKey) as! String;
                
                self.getWhileAttStringWith(value: text, index: currentIndex!);
            }
            
        }
    };
    var currentPort: String?;
    
    
    var hiddenCallBack: HidAlertCallBack?;
    
    public weak var block: Block?;
    
    public var backView: NewAlertView?;
    
    var backColor: UIColor = UIColor.clear;
    
     public var name: String {
        
        didSet {
            
            self.addSubViewWith(typeName: self.name);
        }
        
    };
    
    //title上需要更改值的label
    var imputViews: [UIView] = Array();
    
    var models: [RectModel] = Array();
    
    public init(frame:CGRect, block: Block, backColor: UIColor) {
        
        self.name = block.name;

        self.backColor = backColor;
        
        super.init(frame: frame);
        
        self.block = block;
        
        self.addSubViewWith(typeName: block.name);


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


     func onClink(sender: SelectButton!) {
        
        sender.isSelected = !sender.isSelected;
        
        NSLog("%d", sender.isSelected ?1:0);
    }
    
//MARK: - 添加弹窗相关方法
    open func addSubViewWith(typeName: String) {
        
        
        let style = AlertViewControl.SetBackStyle(typeName: self.name);
        
        let size = CGSize.init(width: 1080, height: 933);
        
        let bundel = Bundle(identifier: "com.google.blockly.Blockly");
        let view = bundel!.loadNibNamed("NewAlertView", owner: nil, options: nil)!.first as! NewAlertView;
        self.backView = view;
        
        self.backView!.backgroundColor = self.backColor;
        self.backView!.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height);
        
        self.backView!.ABStyle = style;
        
        self.backView!.center = self.center;
        
        self.addSubview(self.backView!);
        
        self.createSubView();
        
//        if block != nil {
//            
//            self.updataTitleWithValues(values: block!.getBlockValues());
//
//        }
    }
    
    //显示AlertView
    open func showAlerWith(view: UIView, callBack:@escaping HidAlertCallBack) {
        
        if ["while_start","return_status","start_timer","end_timer","reset_timer","always_repeat","break"].contains(self.name) {
            
            return ;
        }
        
        self.hiddenCallBack = callBack;
        view.addSubview(self);
        
    }
    
    //隐藏alertView
    func hidAlertView() {
        
        if self.hiddenCallBack != nil {
            
            var astrings: [String] = Array();
            
            for label in self.imputViews {
               
                let string = objc_getAssociatedObject(label, &runtimeKey.alertKey) as? String;
                astrings.append(string!);
            }
            
            self.hiddenCallBack!(astrings);
            
        }
        
        self.removeFromSuperview();
        
        
    }
    
    func setRuntime(value: Any, objct:Any) {
        
        objc_setAssociatedObject(objct, &runtimeKey.alertKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    //计算适应屏幕的宽 或 高
    open class func replaceWidth(value: CGFloat) -> CGFloat {
        
        let screenSize = UIApplication.shared.windows.first?.bounds.size;
        var newValue = value / 1920 * screenSize!.width;
        
        return newValue;
        
    }
    
    //设计图 1920 * 1200
    //弹窗  1080 * 940
    open class func resize(size: CGSize) -> CGSize {
        
        let screenSize = UIApplication.shared.windows.first?.bounds.size;
        
        let interFaceIdiom = UIDevice.current.userInterfaceIdiom;
        
        var width = size.width/1920 * screenSize!.width;
        var height = size.height/1920 * screenSize!.width;
        
        //MARK: - 适配iPad和iPhone
        if interFaceIdiom == UIUserInterfaceIdiom.pad {
            
            
        } else if interFaceIdiom == UIUserInterfaceIdiom.phone {
            
            
            
        }
        
        return CGSize(width: width, height: height);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let view = touches.first!.view;
        
        if view == self {
            
            self.hidAlertView();
        }
        
        if self.imputViews.contains(view!) {
            
            if self.currentIndex != nil {
                
                let viewIndex = imputViews.index(of: view!);
                if viewIndex == 1 {
                    let texts = ["or","and"];
                    let label = imputViews[1] as! UILabel;
                    let index = label.text == "and" ? 0 : 1;
                    self.update(value: texts[index], viewIndex: 1);

                } else {
                    self.currentIndex = viewIndex!;
                }
            }
        }
        
    }
    
    //返回弹窗类型
    open class func SetBackStyle(typeName: String) -> alertBackStyle {
        
        //TODO: - 根据 self.typeName判断alertStyle
        
        var style: alertBackStyle = .defaultStyle;
        if typeName == "1" {
            
            style = .defaultStyle;
            
        } else if typeName == "2" {
            
            style = .noFoot;
            
        } else if typeName == "3" {
            
            style = .noFootShout
            
        } else if typeName == "4" {
            
            style = .noFootLong
        }
        
        return style;
    }

    //添加title的约束
    func addTitleLayoutWith(views: [UIView]) {
        
        let superView = self.backView!.titleView!;
        
        let backView = UIView.init();
        
        superView.addSubview(backView);
        
        var newArray: [String : UIView] = Dictionary();
        var names: [String] = Array();
        for i in 0 ..< views.count {
            
            let name = String.init(format: "view%d", i);
            newArray[name] = views[i];
            names.append(name);
        }
        
        backView.bky_addSubviews(views);
        
        var contents: [String] = Array();
        var HS = "H:|-";
        let keys = names;
        for i in 0 ..< keys.count {
            let view = newArray[names[i]];
            let name = keys[i];
            var VS = String.init(format: "V:|-[%@]-|", name);
            
            if view!.isMember(of: UIImageView.self) {
                
                VS = String.init(format: "V:|-[%@(%f)]-|", name,view!.bounds.height);
            }
            
            
            contents.append(VS);
            
            var subHS = String.init(format: "[%@]-(15)-", name);
            if view!.isMember(of: UIImageView.self) {
                
                subHS = String.init(format: "[%@(%f)]-(15)-", name,name,view!.bounds.width);
            }
            if i == keys.count-1 {
                
                subHS = String.init(format: "[%@]-|", name);
                
                if view!.isMember(of: UIImageView.self) {
                    
                    subHS = String.init(format: "[%@(%f)]-|", name,view!.bounds.width);
                }
                
                HS = HS.appending(subHS);
                contents.append(HS);
            } else {
                
                if view!.isMember(of: UIImageView.self) {
                    
                    subHS = String.init(format: "[%@(%f)]-", name,view!.bounds.height);
                }
                
                HS = HS.appending(subHS);
            }
            NSLog("%f", view!.bounds.height);
        }
        
        NSLog("%@", HS);
        
        backView.bky_addVisualFormatConstraints(contents, metrics: nil, views: newArray);
        backView.translatesAutoresizingMaskIntoConstraints = false;
        let HConsta = NSLayoutConstraint.init(item: backView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0);
        
        superView.addConstraint(HConsta);
        
        let VConsta = NSLayoutConstraint.init(item: backView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0);
        superView.addConstraint(VConsta);
        
        
    }
    
    //创建一个label
    func returnLabel(textColor: UIColor, font: UIFont, isChange:Bool) -> UILabel {
        
        let label = NewLabel.init();
        label.textAlignment = .center;
        label.textColor = textColor;
        label.font = font;
        if isChange {
            
            label.layer.masksToBounds = true;
            label.layer.cornerRadius = 5;
            label.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
            self.imputViews.append(label);

        }
        
        return label;
    }

    //创建一个imageView
    func returmImageView(width: CGFloat, image: String) -> UIImageView {
        
        let imageView = UIImageView.init();
        imageView.contentMode = .scaleAspectFit;
        
        imageView.frame = CGRect.init(x: 0, y: 0, width: width*2, height: width);
        imageView.image = UIImage.init(named: image);
        imageView.backgroundColor = UIColor.init(white: 1, alpha: 0.4);
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = 5;
        self.imputViews.append(imageView);
        
        return imageView;

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        
        NotificationCenter.default.removeObserver(self);
    }

}

//MARK : - 自定义label 解决label自适应大小 左右不留白
class NewLabel : UILabel {
 
//    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
//        
//    }
//    
//    override func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
//        
//    }
    
}

@objc(FunctionControl)
class FunctionControl: NSObject {
    
    static let functionControl = { () -> FunctionControl in 
    
        let funcs = FunctionControl.init();
        
        NotificationCenter.default.addObserver(funcs, selector: Selector(("clearFunction")), name: NSNotification.Name("clearFunction"), object: nil)
        
        return funcs;
        
    }();
    
    deinit {
        
        NotificationCenter.default.removeObserver(self);
    }
    
    private override init() {
    
        super.init();
        

    };
    
    public var names: [String : String] = Dictionary();
    
     func clearFunction() {
        
       self.names.removeAll();
    }
    
}


