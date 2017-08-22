//
//  InputNameView.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/25.
//  Copyright © 2017年 text. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputNameView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;

- (void)addEnterTarget:(id)target Action:(SEL)action;

@end
