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
 View for rendering a `FieldImageLayout`.
 */
@objc(BKYFieldImageView)
open class FieldImageView: FieldView {
  // MARK: - Properties

  /// Convenience property for accessing `self.layout` as a `FieldImageLayout`
  open var fieldImageLayout: FieldImageLayout? {
    return layout as? FieldImageLayout
  }

  /// The image to render
  fileprivate lazy var imageView: UIButton = {
    let imageView = UIButton.init(type: UIButtonType.custom);
//    let inset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8);
    imageView.frame = self.bounds
//    imageView.frame = CGRect.init(x: inset.left, y: inset.top, width: self.bounds.width-inset.left*2, height: self.bounds.height - inset.top*2)
    
    imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//    imageView.contentMode = .scaleAspectFill;
    imageView.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2);
    imageView.imageView?.contentMode = .scaleAspectFit;
    
    return imageView
  }()

    lazy var animateView: LightRectCollectionView = {
    
        let animateView = LightRectCollectionView.init(frame: self.bounds);
        animateView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animateView.isHidden = true;
        return animateView;
    }();
    
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let isRespon = self.isResponst(view: self);
        
        if animateView.point(inside: point, with: event) && isRespon {
            
            return animateView;
        }
        
        return super.hitTest(point, with: event);
    
    }

    //2017 07 24 判断是否在WorkbenchViewController上
    private func isResponst(view:UIView) -> Bool {
    
//        if view.isMember(of: ToolboxCategoryViewController) {

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
        
       return self.isResponst(view: view.superview!);
        
    }
    
  // MARK: - Initializers

  /// Initializes the image field view.
  public required init() {
    super.init(frame: CGRect.zero)

    addSubview(imageView)
    addSubview(animateView);
    self.backgroundColor = UIColor.init(white: 1, alpha: 0.3);
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 5;
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

    guard let fieldImageLayout = self.fieldImageLayout else {
      return
    }

    runAnimatableCode(animated) {
      if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
        fieldImageLayout.loadImage(completion: { (image) in
//          self.imageView.image = image
            self.imageView.setImage(image, for: .normal);
            let imageStr = self.fieldImageLayout?.fieldImage.imageLocation;
            if imageStr != nil && imageStr!.contains("#") {
                
                self.animateView.isHidden = false;
                self.animateView.dataString = imageStr;
            }
            
        })
      }
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()

    self.frame = CGRect.zero
//    self.imageView.image = nil
    self.imageView.setImage(nil, for: .normal);
  }
}


// MARK: - FieldLayoutMeasurer implementation

extension FieldImageView: FieldLayoutMeasurer {
  public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
    guard let fieldImageLayout = layout as? FieldImageLayout else {
      bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
        "Expected type `FieldImageLayout`.")
      return CGSize.zero
    }

    return layout.engine.viewSizeFromWorkspaceSize(fieldImageLayout.size)
  }
    
}



