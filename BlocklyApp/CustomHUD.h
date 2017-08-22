//
//  CustomHUD.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface CustomHUD : MBProgressHUD

//message
+ (void)showText:(NSString *)text;
// 菊花+message
+ (void)showwithTextDailog:(NSString *)text;
//饼状图+message
+ (void)showModeDeterminate;
//自定义 可加载图片
+ (void)showCustomView;

+ (void)hidenHUD;


@end
