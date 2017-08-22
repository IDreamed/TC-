//
//  SetTableCell.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetModel.h"

@interface SetTableCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UILabel *nameLabel;

    @property (weak, nonatomic) IBOutlet UIImageView *heardImageView;
    @property (weak, nonatomic) IBOutlet UITextField *inputView;
    @property (strong, nonatomic) SetModel * model;
    - (void)updateCellWithName:(NSString *)name index:(NSInteger)index;
    
@end
