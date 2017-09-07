//
//  UpdateValueModel.h
//  BlocklyApp
//
//  Created by 张 on 2017/9/6.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateValueModel : NSObject

///传感器In1的值
@property (assign, atomic) CGFloat IN1;
///传感器In2的值
@property (assign, atomic) CGFloat IN2;
///传感器In3的值
@property (assign, atomic) CGFloat IN3;

+ (instancetype)sharedValueModel;

+ (void)beginGetValue;

+ (void)endGetValue;

@end
