//
//  RGBLightModel.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/15.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGBLightModel : NSObject

///rgb灯的颜色 黑色为关灯
@property (copy, nonatomic) NSString * RGBColor;
///高亮灯亮度 %0为关灯
@property (assign, nonatomic) UInt8 highlightLevel;
///灯格颜色 黑色为关灯
@property (copy, nonatomic) NSString * light1Color;
//／灯格 等级
@property (assign, nonatomic) UInt8 light1Level;

@end
