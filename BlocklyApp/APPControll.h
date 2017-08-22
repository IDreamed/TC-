//
//  APPControll.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetModel.h"
#import <UIKit/UIKit.h>


@interface APPControll : NSObject
    
+ (void)writeUserId:(NSString *)userId password:(NSString *)password;
    
+ (NSArray *)getUserIdAndPassword;
    
+ (void)registForKeybordNotificationWithObserver:(id)observer showAction:(SEL)showAction hidenAction:(SEL)hidenAction;
    
+ (void)removeKeybordNotificationWithObserver:(id)observer;
    
+ (BOOL)valiMobile:(NSString *)mobile;
    
+ (SetModel *)getUserInfo;
    
+ (void)writeUserInfo:(NSDictionary *)userInfo;
    

+ (NSArray *)getPropertyNamesForClass:(Class)class;
    
+ (CGFloat)blocklyResizeWithWidth:(CGFloat)width;
    
+ (BOOL)writeUpdateSourceToFile:(NSData *)data;

+ (NSData *)getUpdateSource;

+ (NSDictionary *)getTypeDic;
    
@end
