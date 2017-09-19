//
//  updateModel.h
//  BlocklyApp
//
//  Created by 张 on 2017/9/13.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface updateModel : NSObject

///版本描述
@property (copy,nonatomic) NSString * desciption;
///版本名称
@property (copy, nonatomic) NSString * versionName;
///硬件更新包地址
@property (copy,nonatomic) NSString * deviceUrl;
///是否强制更新
@property (assign, nonatomic) NSInteger must;
///硬件版本
@property (assign,nonatomic) CGFloat deviceVersion;
///app版本号
@property (assign, nonatomic) CGFloat versionCode;

+ (void)setModel:(updateModel *)model;

@end
