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
 View for rendering a `FieldDropdownLayout`.
 */
@objc(BKYFieldDropdownView)
open class FieldDropdownView: FieldView {
  // MARK: - Properties

  /// Convenience property for accessing `self.layout` as a `FieldDropdownLayout`
  open var fieldDropdownLayout: FieldDropdownLayout? {
    return layout as? FieldDropdownLayout
  }

  /// The dropdown to render
  fileprivate lazy var dropDownView: DropdownView = {
    let dropDownView = DropdownView()
    dropDownView.delegate = self
    return dropDownView
  }()

    ////2017 08 16  函数的options
    public var options: [(displayName: String, value: String)] = Array();
    
  // MARK: - Initializers

  /// Initializes the dropdown field view.
  public required init() {
    super.init(frame: CGRect.zero)

    // Add subviews
    configureSubviews()
  }

  /**
   :nodoc:
   - Warning: This is currently unsupported.
   */
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Called unsupported initializer")
  }

  // MARK: - Super

  open override func refreshView(
    forFlags flags: LayoutFlag = LayoutFlag.All, animated: Bool = false)
  {
    super.refreshView(forFlags: flags, animated: animated)

    guard let fieldDropdownLayout = self.fieldDropdownLayout else {
      return
    }

    runAnimatableCode(animated) {
      if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
        let dropDownView = self.dropDownView
        dropDownView.text = fieldDropdownLayout.selectedOption?.displayName
        dropDownView.borderWidth =
          fieldDropdownLayout.config.viewUnit(for: LayoutConfig.FieldLineWidth)
        dropDownView.borderCornerRadius =
          fieldDropdownLayout.config.viewUnit(for: LayoutConfig.FieldCornerRadius)
        dropDownView.textFont = fieldDropdownLayout.config.font(for: LayoutConfig.GlobalFont)
        dropDownView.textColor =
          fieldDropdownLayout.config.color(for: LayoutConfig.FieldEditableTextColor)
      }
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()

    dropDownView.text = ""
  }

  // MARK: - Private

  fileprivate func configureSubviews() {
    let views: [String: UIView] = ["dropDownView": dropDownView]
    let constraints = [
      "H:|[dropDownView]|",
      "V:|[dropDownView]|",
    ]
    bky_addSubviews(Array(views.values))
    bky_addVisualFormatConstraints(constraints, metrics: nil, views: views)
    
  }

}

// MARK: - FieldLayoutMeasurer implementation

extension FieldDropdownView: FieldLayoutMeasurer {
  public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
    guard let fieldDropdownLayout = layout as? FieldDropdownLayout else {
      bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
        "Expected type `FieldDropdownLayout`.")
      return CGSize.zero
    }

    let borderWidth = layout.config.viewUnit(for: LayoutConfig.FieldLineWidth)
    let xSpacing = layout.config.viewUnit(for: LayoutConfig.InlineXPadding)
    let ySpacing = layout.config.viewUnit(for: LayoutConfig.InlineYPadding)
    let measureText = (fieldDropdownLayout.selectedOption?.displayName ?? "")
    let font = layout.config.font(for: LayoutConfig.GlobalFont)

    return DropdownView.measureSize(
      text: measureText, dropDownArrowImage: DropdownView.defaultDropDownArrowImage(),
      textFont: font, borderWidth: borderWidth, horizontalSpacing: xSpacing,
      verticalSpacing: ySpacing)
  }
}

// MARK: - DropDownViewDelegate Implementation

extension FieldDropdownView: DropdownViewDelegate {
  public func dropDownDidReceiveTap() {
    guard let fieldDropdownLayout = self.fieldDropdownLayout else {
      return
    }
    var options:[(displayName: String, value: String)] = Array();
    var currentIndex = 0;

    if (self.fieldDropdownLayout?.field.name == "doFunction") {
        
        ////2017 08 15 根据以定义函数生成数据源
        let functions = FunctionControl.functionControl.names;
        
        var index = 0;
        for e in functions {
            
            let name = e.value;
            options.append((displayName: name, value: name));
            if self.dropDownView.text == e.value {
                currentIndex = index;
            }
            index += 1;
            
        }
        
        self.options = options;
        self.fieldDropdownLayout?.fieldDropdown.options = self.options;
        self.fieldDropdownLayout?.fieldDropdown.selectedIndex = currentIndex;
        
        if self.options.count == 0 {
            
            return ;
        }
    }
    if (self.fieldDropdownLayout?.field.name == "doFunction") {
        
        ////2017 08 15 根据以定义函数生成数据源
        let functions = FunctionControl.functionControl.names;
        
        
        var index = 0;
        for e in functions {
            
            let name = e.key;
            options.append((displayName: name, value: name));
            if self.dropDownView.text == e.value {
                currentIndex = index;
            }
            index += 1;
            
        }
        self.options = options;
        self.fieldDropdownLayout?.fieldDropdown.options = self.options;
        self.fieldDropdownLayout?.fieldDropdown.selectedIndex = currentIndex;
        
        if self.options.count == 0 {
            
            return ;
        }
    }
    
    
    let viewController = DropdownOptionsViewController()
    viewController.delegate = self
    viewController.options = fieldDropdownLayout.options
//    viewController.options = self.options;
    viewController.selectedIndex = fieldDropdownLayout.selectedIndex
//    viewController.selectedIndex = currentIndex;
    viewController.textLabelFont =
      fieldDropdownLayout.config.popoverFont(for: LayoutConfig.GlobalFont)
    viewController.textLabelColor =
      fieldDropdownLayout.config.color(for: LayoutConfig.FieldEditableTextColor)

    popoverDelegate?
      .layoutView(self, requestedToPresentPopoverViewController: viewController, fromView: self)
  }
}

// MARK: - DropdownOptionsViewControllerDelegate

extension FieldDropdownView: DropdownOptionsViewControllerDelegate {
  public func dropdownOptionsViewController(
    _ viewController: DropdownOptionsViewController, didSelectOptionIndex optionIndex: Int)
  {
    EventManager.sharedInstance.groupAndFireEvents {
      fieldDropdownLayout?.updateSelectedIndex(optionIndex)
      popoverDelegate?.layoutView(
        self, requestedToDismissPopoverViewController: viewController, animated: true)
    }
  }
}
