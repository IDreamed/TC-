//
//  PersonalWorksCell.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/7.
//  Copyright © 2017年 text. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalWorksModel.h"

@class PersonalWorksCell;

typedef void(^ColCellCallback)(PersonalWorksCell * cell) ;

@interface PersonalWorksCell : UICollectionViewCell
    
@property (nonatomic, copy) ColCellCallback deleteCallback;

@property (nonatomic, weak) PersonalWorksModel * model;

- (void)updateValueWithModel:(PersonalWorksModel *)model;

@end
