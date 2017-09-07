//
//  GetValueModle.h
//  BlocklyApp
//
//  Created by 张 on 2017/8/23.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetValueModle : NSObject

@property (nonatomic, copy) NSString * blockName;
///数据的类型 数字 number 对错 bool 颜色 colour 字符串 string
//@property (nonatomic, copy) NSString * valueType;

///value值的封装
//@property (nonatomic, copy) NSString * value;

@property (nonatomic, copy) NSString * stringValue;

@property (nonatomic, assign) BOOL boolValue;

@property (nonatomic, copy) NSString * colourValue;

@property (nonatomic, assign) CGFloat numberValue;

@property (nonatomic, copy) NSString * valueName;


- (void)getvalueForSelf;

@end
