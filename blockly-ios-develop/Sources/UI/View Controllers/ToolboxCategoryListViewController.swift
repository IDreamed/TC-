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

// MARK: - ToolboxCategoryListViewControllerDelegate (Protocol)

/**
 Handler for events that occur on `ToolboxCategoryListViewController`.
 */
@objc(BKYToolboxCategoryListViewControllerDelegate)
public protocol ToolboxCategoryListViewControllerDelegate: class {
  /**
  Event that occurs when a category has been selected.
  */
  func toolboxCategoryListViewController(
    _ controller: ToolboxCategoryListViewController, didSelectCategory category: Toolbox.Category)

  /**
  Event that occurs when the category selection has been deselected.
  */
  func toolboxCategoryListViewControllerDidDeselectCategory(
    _ controller: ToolboxCategoryListViewController)
}

// MARK: - ToolboxCategoryListViewController (Class)

/**
 A view for displaying a vertical list of categories from a `Toolbox`.
 */
@objc(BKYToolboxCategoryListViewController)
public final class ToolboxCategoryListViewController: UICollectionViewController {

  // MARK: - Constants

  /// Possible view orientations for the toolbox category list
  @objc(BKYToolboxCategoryListViewControllerOrientation)
  public enum Orientation: Int {
    case
      /// Specifies the toolbox is horizontally-oriented.
      horizontal = 0,
      /// Specifies the toolbox is vertically-oriented.
      vertical
  }

  // MARK: - Properties

  /// The orientation of how the categories should be laid out
  public let orientation: Orientation

  /// The toolbox layout to display
  public var toolboxLayout: ToolboxLayout?

  /// The category that the user has currently selected
  public var selectedCategory: Toolbox.Category? {
    didSet {
      if selectedCategory == oldValue {
        return
      }

      // Update the UI to match the new selected category.

      if selectedCategory != nil,
        let indexPath = indexPath(forCategory: selectedCategory),
        let cell = self.collectionView?.cellForItem(at: indexPath) , !cell.isSelected
      {
        // Select the new value (which automatically deselects the previous value)
        self.collectionView?.selectItem(
          at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
      } else if selectedCategory == nil,
        let indexPath = indexPath(forCategory: oldValue)
      {
        // No new category was selected. Just de-select the previous value.
        self.collectionView?.deselectItem(at: indexPath, animated: true)
      }
    }
  }

  /// Delegate for handling category selection events
  public weak var delegate: ToolboxCategoryListViewControllerDelegate?

  // MARK: - Initializers

  /**
   Initializes the toolbox category list view controller.

   - parameter orientation: The `Orientation` for the view.
   */
  public required init(orientation: Orientation) {
    self.orientation = orientation

    let flowLayout = UICollectionViewFlowLayout()
    
    switch orientation {
    case .horizontal:
      flowLayout.scrollDirection = .horizontal
    case .vertical:
      flowLayout.scrollDirection = .vertical
    }

    super.init(collectionViewLayout: flowLayout)
    
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(ToolboxCategoryListViewController.resizeFloat(value: 50), 0, ToolboxCategoryListViewController.resizeFloat(value: 50),0);
    self.collectionView?.backgroundColor = UIColor.init(white: 0.87, alpha: 1);
  }

  /**
   :nodoc:
   - Warning: This is currently unsupported.
   */
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Called unsupported initializer")
  }

  // MARK: - Super

  open override func viewDidLoad() {
    super.viewDidLoad()

    guard let collectionView = self.collectionView else {
      bky_print("`self.collectionView` is nil. Did you forget to set it?")
      return
    }

    collectionView.backgroundColor = UIColor.white
    collectionView.register(ToolboxCategoryListViewCell.self,
      forCellWithReuseIdentifier: ToolboxCategoryListViewCell.ReusableCellIdentifier)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false

    // Automatically constrain this view to a certain size
    if orientation == .horizontal {
      view.bky_addHeightConstraint(ToolboxCategoryListViewCell.CellHeight)
    } else {
      // `ToolboxCategoryListViewCell.CellHeight` is used since in the vertical orientation,
      // cells are rotated by 90 degrees
      view.bky_addWidthConstraint(ToolboxCategoryListViewCell.CellHeight)
    }
  }
    
    //MARK: -2017 05 24 修改 添加计算尺寸方法
    public class func resizeFloat(value:CGFloat) -> CGFloat {
        
        //获取屏幕大小 进行尺寸的变更 模版为320*480
        let screenSzie = UIApplication.shared.windows.first?.bounds.size;
        
        let newValue = value/480*(screenSzie?.width)!;
        
        return newValue;
        
    }

  // MARK: - Public

  /**
   Refreshes the UI based on the current version of `self.toolbox`.
   */
  public func refreshView() {
    self.collectionView?.reloadData()
  }

  // MARK: - UICollectionViewDataSource overrides

  public override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public override func collectionView(
    _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return toolboxLayout?.categoryLayoutCoordinators.count ?? 0
  }

  public override func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ToolboxCategoryListViewCell.ReusableCellIdentifier,
        for: indexPath) as! ToolboxCategoryListViewCell
      cell.loadCategory(category(forIndexPath: indexPath), orientation: orientation)
      cell.isSelected = (selectedCategory == cell.category)
    
    
      return cell
  }
    
    


  // MARK: - UICollectionViewDelegate overrides

  public override func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
  {
    let cell = collectionView.cellForItem(at: indexPath) as! ToolboxCategoryListViewCell

    if selectedCategory == cell.category {
      // If the category has already been selected, de-select it
      self.selectedCategory = nil
      delegate?.toolboxCategoryListViewControllerDidDeselectCategory(self)
    } else {
      // Select the new category
      self.selectedCategory = cell.category

      if let category = cell.category {
        delegate?.toolboxCategoryListViewController(self, didSelectCategory: category)
      }
    }
  }

  // MARK: - Private

  fileprivate func indexPath(forCategory category: Toolbox.Category?) -> IndexPath? {
    if toolboxLayout == nil || category == nil {
      return nil
    }

    for i in 0 ..< toolboxLayout!.categoryLayoutCoordinators.count {
      if toolboxLayout!.categoryLayoutCoordinators[i].workspaceLayout.workspace == category {
        return IndexPath(row: i, section: 0)
      }
    }
    return nil
  }

  fileprivate func category(forIndexPath indexPath: IndexPath) -> Toolbox.Category {
    return toolboxLayout!.categoryLayoutCoordinators[(indexPath as NSIndexPath).row].workspaceLayout.workspace
      as! Toolbox.Category
  }
}

extension ToolboxCategoryListViewController: UICollectionViewDelegateFlowLayout {
  // MARK: - UICollectionViewDelegateFlowLayout implementation

  public func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let indexedCategory = category(forIndexPath: indexPath)
    var size = ToolboxCategoryListViewCell.sizeRequired(forCategory: indexedCategory)
    
    size = CGSize(width: ToolboxCategoryListViewController.resizeFloat(value: 25), height: ToolboxCategoryListViewController.resizeFloat(value:70));

    // Flip width/height for the vertical orientation (its contents are actually rotated 90 degrees)
    return (orientation == .vertical) ? CGSize(width: size.height, height: size.width) : size
  }
}


// MARK: - ToolboxCategoryListViewCell (Class)

/**
 An individual cell category list view cell.
*/
@objc(BKYToolboxCategoryListViewCell)
private class ToolboxCategoryListViewCell: UICollectionViewCell {
  static let ReusableCellIdentifier = "ToolboxCategoryListViewCell"

  static let ColorTagViewHeight = CGFloat(0)
  static var iconInsets = UIEdgeInsetsMake(2, 2.5, 2, 2.5)
  static let LabelInsets = UIEdgeInsetsMake(2,4,2,4)
    static let CellHeight = ToolboxCategoryListViewController.resizeFloat(value: 70);
    static let IconSize = CGSize(width: ToolboxCategoryListViewController.resizeFloat(value: 14), height: ToolboxCategoryListViewController.resizeFloat(value: 14));

  /// The category this cell represents
  var category: Toolbox.Category?

  /// Subview holding all contents of the cell
  let rotationView = UIView()

  /// Label for the category name
  let nameLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = NSTextAlignment.center
    view.font = ToolboxCategoryListViewCell.fontForNameLabel()
    return view
  }()

  /// Image for the category icon
  let iconView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()

  /// View representing the category's color
  let colorTagView = UIView()

  override var isSelected: Bool {
    didSet {
      self.backgroundColor = isSelected ?
        category?.color.withAlphaComponent(0.2) : UIColor(white: 1, alpha: 0.7)
    }
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureSubviews()
  }

  // MARK: - Super

  override func prepareForReuse() {
    rotationView.transform = CGAffineTransform.identity
    nameLabel.text = ""
    iconView.image = nil
    colorTagView.backgroundColor = UIColor.clear
    isSelected = false
  }

  // MARK: - Private

  func configureSubviews() {
    
    self.autoresizesSubviews = true
    self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.translatesAutoresizingMaskIntoConstraints = true

    self.contentView.frame = self.bounds
    self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.contentView.translatesAutoresizingMaskIntoConstraints = true

    // Create a view specifically dedicated to rotating its contents (rotating the contentView
    // causes problems)
    rotationView.frame =
      CGRect(x: 0, y: 0,
             width: self.contentView.bounds.height, height: self.contentView.bounds.width)
    rotationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    rotationView.autoresizesSubviews = true
    self.contentView.addSubview(rotationView)

    // NOTE: The following views weren't created using auto-layout constraints since they don't mix
    // well with `rotationView.transform`, which is required for rotating the view.

    // Create color tag for the top of the view
    colorTagView.frame = CGRect(x: 0, y: 0, width: rotationView.bounds.width,
                                    height: ToolboxCategoryListViewCell.ColorTagViewHeight)
    colorTagView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
    rotationView.addSubview(colorTagView)
    
    // Create category name label for the bottom of the view
    
    let iconSize = ToolboxCategoryListViewCell.IconSize;
    
    let left = (rotationView.bounds.width - iconSize.width)/2;
    let top = left/5*4;
    
    
    let iconInsets = UIEdgeInsets(top:top, left:left, bottom:top, right: left);
    ToolboxCategoryListViewCell.iconInsets = iconInsets;
    
    
    iconView.frame = CGRect(x:iconInsets.left,y:colorTagView.bounds.height+10 + iconInsets.top,
                            width:ToolboxCategoryListViewCell.IconSize.width,height:ToolboxCategoryListViewCell.IconSize.height);
    iconView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    iconView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2);
    
    rotationView.addSubview(iconView)

    
    // Create category name label for the bottom of the view
    let labelInsets = ToolboxCategoryListViewCell.LabelInsets
//    nameLabel.frame =
//      CGRect(x: labelInsets.left,
//             y: iconView.bounds.height + iconView.frame.origin.y + labelInsets.top,
//             width: rotationView.bounds.width - labelInsets.left - labelInsets.right,
//             height: rotationView.bounds.height - colorTagView.bounds.height-iconView.bounds.height
//              - labelInsets.top - labelInsets.bottom)
    
    nameLabel.frame = CGRect(x: labelInsets.left,
                             y: iconView.bounds.height + colorTagView.bounds.height + iconView.frame.origin.y,
                             width: rotationView.bounds.height - iconView.frame.origin.y - iconView.bounds.height - labelInsets.bottom - labelInsets.top,
                             height:rotationView.bounds.width - labelInsets.left - labelInsets.right);
    
    let center = CGPoint(x:rotationView.bounds.width/2, y:(rotationView.bounds.height + iconView.bounds.height + iconView.frame.origin.y)/2);
    nameLabel.center = center
    nameLabel.transform = CGAffineTransform.init(rotationAngle:CGFloat.pi/2);
    nameLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    rotationView.addSubview(nameLabel)
    
    
//    let line = UIView.init(frame: CGRect(x: 0, y: 0, width: 0.5, height: rotationView.bounds.height));
//    
//    line.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3);
//    rotationView.addSubview(line);
//    let line1 = UIView.init(frame: CGRect(x: rotationView.bounds.width - 1, y: 0, width: 0.5, height: rotationView.bounds.height));
//    line.backgroundColor = UIColor.init(white: 1, alpha: 0.3);
//    rotationView.addSubview(line1);
    
    
    


     }

  // MARK: - Private

  func loadCategory(_ category: Toolbox.Category,
    orientation: ToolboxCategoryListViewController.Orientation)
  {
    self.category = category

    if let icon = category.icon {
      iconView.image = icon
    }
    
    ///2017 07 26 修改颜色
    category.color = self.colorWithIndex(text: category.name);
    
    nameLabel.text = category.name
    nameLabel.textColor = category.color;
    colorTagView.backgroundColor = category.color
    
    

    let size = ToolboxCategoryListViewCell.sizeRequired(forCategory: category)
    rotationView.center = self.contentView.center // We need the rotation to occur in the center
    rotationView.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    if orientation == .vertical {
      // Rotate by -90° so the category appears vertically
      rotationView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)

      // We want icons to appear right-side up, so we un-rotate them by 90°
      iconView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
    }
  }

    ////2017 07 26 修改颜色
    func colorWithIndex(text: String) -> UIColor {
        
        var h: CGFloat = 0;
        var b: CGFloat = 0;
        var s: CGFloat = 0;
        
        if text == "开始" {
            h = 29;
            b =  0.96;
            s = 0.76;
        }
        if text == "电机" {
            h = 340;
            b =  0.97;
            s = 0.64;
        }
        if text == "灯光" {
            h = 171;
            b =  0.82;
            s = 0.74;
        }
        if text == "声音" {
            h = 206;
            b =  0.83;
            s = 0.83;
        }
        if text == "控制" {
            h = 312;
            b =  0.99;
            s = 0.63;
            
        }
        if text == "变量" {
            h = 234;
            b = 0.98;
            s = 0.54;
        }
        
        if text == "端口" {
            h = 0.557 * 360;
            s = 0.633;
            b = 0.961;
        }
        
        if text == "时间" {
            
            h = 0.294 * 360;
            s = 0.635;
            b = 0.784;
        }
        
        if text == "数学" {
            h = 0.769 * 360;
            s = 0.577;
            b = 0.761;
        }
        
        if text == "事件" {
        
            h = 0.023 * 260;
            s = 0.769;
            b = 1;
        }
        
        return UIColor.init(hue: h/360.0, saturation: s, brightness: b, alpha: 1);
        
    }

    
  static func sizeRequired(forCategory category: Toolbox.Category) -> CGSize {
    var size: CGSize
    if let icon = category.icon {
      size = CGSize(width: max(icon.size.width, IconSize.width),
                    height: max(icon.size.height, IconSize.height))
    } else {
      size = category.name.bky_singleLineSize(forFont: fontForNameLabel())
    }

    return CGSize(width: ToolboxCategoryListViewController.resizeFloat(value: 25), height: CellHeight)
  }

  static func fontForNameLabel() -> UIFont {
    
    return UIFont.systemFont(ofSize: ToolboxCategoryListViewController.resizeFloat(value: 11))
  }
}
