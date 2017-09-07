//
//  CustomHUD.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "CustomHUD.h"
#import <MBProgressHUD.h>

static MBProgressHUD * HUD;

@implementation CustomHUD

//    typedefNS_ENUM(NSInteger, MBProgressHUDMode) {
//
//        /** Progress is shown using an UIActivityIndicatorView. This is the default. */
//
//        MBProgressHUDModeIndeterminate,//默认的小菊花转动的样式
//
//        /** Progress is shown using a round, pie-chart like, progress view. */
//
//        MBProgressHUDModeDeterminate,//用一个圆，饼状图的样式
//
//        /** Progress is shown using a horizontal progress bar */
//
//        MBProgressHUDModeDeterminateHorizontalBar,//水平进度条
//
//        /** Progress is shown using a ring-shaped progress view. */
//
//        MBProgressHUDModeAnnularDeterminate,//圆环状的进度条
//
//        /** Shows a custom view */
//
//        MBProgressHUDModeCustomView,//自定义视图，可以添加自定义图片
//
//        /** Shows only labels */
//
//        MBProgressHUDModeText//只显示标签提示，如“加载中......”
//
//    };

+(void)showText:(NSString*)string

{
    
    if ([NSThread currentThread] == [NSThread mainThread]) {
        
        [CustomHUD setShowText:string];

    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [CustomHUD setShowText:string];

        });
        
    }
}

+ (void)setShowText:(NSString *)string {
    
    @synchronized(HUD){
        
        UIWindow * window = [[[UIApplication sharedApplication] windows] lastObject];
        
        if(!HUD) {
            
            HUD= [[MBProgressHUD alloc]initWithView:window];
            
            [window addSubview:HUD];
            
        }
        
        HUD.mode=MBProgressHUDModeText;// 样式，可以根据需要修改
        
        HUD.label.text= string;//提示框的文字
        
        [HUD showAnimated:YES];//提示框出现
        
        [HUD hideAnimated:YES afterDelay:1.5];
        
    }
}

+ (void)showwithTextDailog:(NSString *)text {
    
    @synchronized(HUD){
        
        UIWindow * window = [[[UIApplication sharedApplication] windows] lastObject];
        
        if(!HUD) {
            
            HUD= [[MBProgressHUD alloc]initWithView:window];
            
            [window addSubview:HUD];
            
        }
        
        HUD.mode=MBProgressHUDModeIndeterminate;// 样式，可以根据需要修改
        
        HUD.label.text= text;//提示框的文字
        
        [HUD showAnimated:YES];//提示框出现
        
        
    }
}

+ (void)hidenHUD {
    
    
    [HUD hideAnimated:YES];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
