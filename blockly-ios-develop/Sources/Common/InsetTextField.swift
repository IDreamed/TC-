/*
 * Copyright 2016 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/**
 A subclass of `UITextField` that allows for setting the padding around the text.
 */
@objc(BKYInsetTextField)
open class InsetTextField: UITextField {
  // MARK: - Properties

  /// The amount of padding that should be added around the text
  open var insetPadding = EdgeInsets() {
    didSet {
      _uiEdgeInsetPadding = bky_UIEdgeInsetsMake(
        insetPadding.top, insetPadding.leading, insetPadding.bottom, insetPadding.trailing)
    }
  }

  /// The amount of padding that should be added around the text, irrespective of layout
  /// direction.
  fileprivate var _uiEdgeInsetPadding = UIEdgeInsets.zero

  // MARK: - Super

  /**
   Returns the `CGRect` describing the bounds of the inset text, including padding.

   - parameter bounds: The `CGRect` of the inset text only.
   - returns: The `CGRect` including the padding.
   */
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    
    self.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.3);
    
    return UIEdgeInsetsInsetRect(bounds, _uiEdgeInsetPadding)
  }

  /**
   Returns the `CGRect` describing the bounds of the editing text, including padding.

   - parameter bounds: The `CGRect` of the editing text only.
   - returns: The `CGRect` including the padding.
   */
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, _uiEdgeInsetPadding)
  }
    
    
    ///2017 05 20 修改点击方法
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
//        let isRespon = InsetTextField.isResponst(view: self);
//        
//        if self.point(inside: point, with: event) && isRespon {
//            
//            return self;
//        }
        
        return super.hitTest(point, with: event);
        
    }
//
//    //    2017 05 23  修改  点击事件
//    open func tapAction(view : UIView) {
//        
////        NSLog("view:%@  superview:%@",view,view.superview!);
//        
//        let sView = self.searchTypeFor(view: view)!;
//        let typeName = sView.defaultBlockLayout?.block.name;
//        
//        NSLog("%@",typeName!);
//        
//        
//    }
    
    //    2017 05 23  修改  查找响应者 区分工具栏和工作空间
    open class func isResponst(view:UIView) -> Bool {
        
        
        let responst = view.next;
        
        if responst == nil {
            return false;
        }
        
        if responst!.isMember(of: ToolboxCategoryViewController.self) {
            
            return false;
        }
        
        if responst!.isMember(of: WorkbenchViewController.self) {
            return true;
        }
        
        return InsetTextField.isResponst(view: view.superview!);
        
    }

    //2017 05 23 查找父视图 DefaultBlovkView 为了拿到本是图的type
    
    open class func searchTypeFor(view : UIView) -> DefaultBlockView? {
        
        let sview = view.superview;
        
        if sview == nil {
            
            return nil;
        }
        
        if sview!.isMember(of: DefaultBlockView.self) {
            
            let dView = sview as! DefaultBlockView;
            
            return dView;
            
        } else {
            
            return self.searchTypeFor(view: sview!);
        }
        
    }
    
}
