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
 View for rendering a `FieldInputLayout`.
 */
@objc(BKYFieldInputView)
open class FieldInputView: FieldView {
  // MARK: - Properties

  /// Convenience property for accessing `self.layout` as a `FieldInputLayout`
  open var fieldInputLayout: FieldInputLayout? {
    return layout as? FieldInputLayout
  }

  /// The text field to render
  open fileprivate(set) lazy var textField: InsetTextField = {
    let textField = InsetTextField(frame: CGRect.zero)
    textField.delegate = self
//    textField.borderStyle = .roundedRect
    textField.borderStyle = .none
    textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    textField.keyboardType = .default
    textField.adjustsFontSizeToFitWidth = false
    textField
      .addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    textField.layer.masksToBounds = true;
    textField.layer.cornerRadius = 5;
//    textField.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor;
//    textField.layer.borderWidth = 1.0
    
    // There is an iPhone 7/7+ simulator (and possibly device) bug where the user can't edit the
    // text field. Setting an empty input accessory view seems to fix this problem.
    textField.inputAccessoryView = UIView(frame: CGRect.zero)

    return textField
  }()

  // MARK: - Initializers

  /// Initializes the input field view.
  public required init() {
    super.init(frame: CGRect.zero)

    addSubview(textField)
  }

  /**
   :nodoc:
   - Warning: This is currently unsupported.
   */
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Called unsupported initializer")
  }
    
    public var backViewLayer: CALayer?

  // MARK: - Super


  open override func refreshView(
    forFlags flags: LayoutFlag = LayoutFlag.All, animated: Bool = false)
  {
    super.refreshView(forFlags: flags, animated: animated)

    guard let fieldInputLayout = self.fieldInputLayout else {
      return
    }

    runAnimatableCode(animated) {
      if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
        let text = fieldInputLayout.currentTextValue
        let textField = self.textField
        if textField.text != text {
          
            if self.backViewLayer != nil {
                self.backViewLayer!.removeFromSuperlayer();
                
            }
            textField.text = text;
        }

        textField.font = fieldInputLayout.config.font(for: LayoutConfig.GlobalFont)
        textField.textColor =
          fieldInputLayout.config.color(for: LayoutConfig.FieldEditableTextColor)
        textField.insetPadding =
          fieldInputLayout.config.edgeInsets(for: LayoutConfig.FieldTextFieldInsetPadding)
        
        
      }
    }
  }

    class func imageNameWith(value: String) -> String {
        
        let dic: [String: String] = ["gj_yanse_bai_1":"0001",
                                     "gj_yanse_hei_1":"0002",
                                     "gj_yanse_hong_1":"0003",
                                     "gj_yanse_lv_1":"0004",
                                     "gj_yanse_lan_1":"0005",
                                     "gj_yanse_huang_1":"0006",
                                     "gj_yanse_pin_1":"0007",
                                     "gj_yanse_qing_1":"0008",
                                     "gj_yanse_cheng_1":"0009",

                                     "bl_sanjiao_2":"0021",
                                     "bl_xingxing_2":"0010",
                                     "bl_yuan_2":"0011",
                                     "bl_fang_2":"0012",
                                     "gj_jia":"0013",
                                     "gj_jian":"0014",
                                     "gj_cheng":"0015",
                                     "gj_chu":"0016",
                                     "gj_dayu":"0017",
                                     "gj_xiaoyu":"0018",
                                     "gj_dengyu":"0019",
                                     "gj_budengyu":"0020",];
        
        
        let string = value.components(separatedBy: "|")[1];
        
        var image = "";
        for key in Array(dic.keys) {
            
            if string == dic[key] {
                image = key;
            }
        }
        
        return image;
    }
    
    class func returnValueWith(imageName: String) -> String {
        
        let dic: [String: String] = ["gj_yanse_bai_1":"0001",
                                     "gj_yanse_hei_1":"0002",
                                     "gj_yanse_hong_1":"0003",
                                     "gj_yanse_lv_1":"0004",
                                     "gj_yanse_lan_1":"0005",
                                     "gj_yanse_huang_1":"0006",
                                     "gj_yanse_pin_1":"0007",
                                     "gj_yanse_qing_1":"0008",
                                     "gj_yanse_cheng_1":"0009",
                                     "bl_sanjiao_2":"0021",
                                     "bl_xingxing_2":"0010",
                                     "bl_yuan_2":"0011",
                                     "bl_fang_2":"0012",
                                     "gj_jia":"0013",
                                     "gj_jian":"0014",
                                     "gj_cheng":"0015",
                                     "gj_chu":"0016",
                                     "gj_dayu":"0017",
                                     "gj_xiaoyu":"0018",
                                     "gj_dengyu":"0019",
                                     "gj_budengyu":"0020",];
        
        let value = String.init(format: "|%@", dic[imageName]!);
        
        return value;
        
    }
    
    
  open override func prepareForReuse() {
    super.prepareForReuse()

    textField.text = ""
  }

  // MARK: - Private

  fileprivate dynamic func textFieldDidChange(_ sender: UITextField) {
    // Update the current text value, but don't commit the new text value yet
    fieldInputLayout?.currentTextValue = self.textField.text ?? ""
  }
}

// MARK: - UITextFieldDelegate

extension FieldInputView: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // This will dismiss the keyboard
    textField.resignFirstResponder()
//    NSLog("taptap")

    return true
  }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    EventManager.sharedInstance.groupAndFireEvents {
      // Only commit the change after the user has finished editing the field
      fieldInputLayout?.updateText(self.textField.text ?? "")
        
        let name = self.fieldInputLayout?.field.name;
        let uuid = self.fieldInputLayout!.fieldInput.sourceInput!.sourceBlock!.uuid;
        if name == "function" {
            
            let contr = FunctionControl.functionControl;
            
            let uuid = uuid
            
            contr.names[uuid] = textField.text!;
        }

    }
  }
}

// MARK: - FieldLayoutMeasurer implementation

extension FieldInputView: FieldLayoutMeasurer {
  public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
    guard let fieldInputLayout = layout as? FieldInputLayout else {
      bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
        "Expected type `FieldInputLayout`.")
      return CGSize.zero
    }

    let textPadding = layout.config.edgeInsets(for: LayoutConfig.FieldTextFieldInsetPadding)
    let maxWidth = layout.config.viewUnit(for: LayoutConfig.FieldTextFieldMaximumWidth)
//    let measureText = fieldInputLayout.currentTextValue + " "
    var measureText = fieldInputLayout.currentTextValue + " ";
   
    let font = fieldInputLayout.config.font(for: LayoutConfig.GlobalFont)
    var measureSize = CGSize.zero;

    if measureText.contains(",") {
        
        let array: [String] = measureText.components(separatedBy: ",");
        if array[0] != "" {
            
            measureText = array[0] + " ";
                    
            measureSize = measureText.bky_singleLineSize(forFont: font)
            measureSize.height += textPadding.top + textPadding.bottom
            measureSize.width =
            min(measureSize.width + textPadding.leading + textPadding.trailing, maxWidth)
           
            
        } else if array[1] != "" {
            
            measureSize = measureText.bky_singleLineSize(forFont: font)
            measureSize.height += textPadding.top + textPadding.bottom
            measureSize.width = 40 + textPadding.leading + textPadding.trailing;
        }
    } else {
        
        measureSize = measureText.bky_singleLineSize(forFont: font)
        measureSize.height += textPadding.top + textPadding.bottom
        measureSize.width =
            min(measureSize.width + textPadding.leading + textPadding.trailing, maxWidth)
    }
    
   
    return measureSize
  }
}
