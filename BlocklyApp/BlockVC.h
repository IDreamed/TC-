//
//  ViewController.h
//  BlocklyApp
//
//  Created by 张 on 2017/5/25.
//  Copyright © 2017年 text. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlockVC : SuperViewController

@property (nonatomic, assign) BOOL isHighLive;

@property (strong, nonatomic) UILabel * titleLabel;

///是否为更改
@property (nonatomic, assign) BOOL isChange;
///作品ID
@property (nonatomic, copy) NSString * wid;
///block字符串
@property (nonatomic, copy) NSString * content;
///程序标题
@property (nonatomic, copy) NSString * appTitle;

- (void)showVlaueView:(BOOL)isShow;

@end

