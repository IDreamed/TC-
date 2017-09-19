//
//  APPControll.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "APPControll.h"
#import <UIKit/UIKit.h>
#import <MJExtension.h>

#define LOGIN_PLIST @"/Documents/login.plist"
#define UPDATE_FILE_PATH @"/Documents/sirui.bin"

@implementation APPControll

+ (void)writeUserId:(NSString *)userId password:(NSString *)password
{
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:LOGIN_PLIST];
    
    NSArray * array = @[userId, password];
    
    [array writeToFile:path atomically:YES];
    
}
    
+ (NSArray *)getUserIdAndPassword
{
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:LOGIN_PLIST];
    

    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    
    return array;
}
    

    
+ (void)registForKeybordNotificationWithObserver:(id)observer showAction:(SEL)showAction hidenAction:(SEL)hidenAction
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    if (showAction) {
        
        [center addObserver:observer selector:showAction name:UIKeyboardWillShowNotification  object:nil];
    }
    
    if (hidenAction) {
        [center addObserver:observer selector:hidenAction name:UIKeyboardWillHideNotification object:nil];
    }
    
}
+ (void)removeKeybordNotificationWithObserver:(id)observer
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:observer];
}
    
    //判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
    {
        mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (mobile.length != 11)
        {
            return NO;
        }else{
            /**
             * 移动号段正则表达式
             */
            NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
            /**
             * 联通号段正则表达式
             */
            NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
            /**
             * 电信号段正则表达式
             */
            NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
            BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
            BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
            NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
            BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
            
            if (isMatch1 || isMatch2 || isMatch3) {
                return YES;
            }else{
                return NO;
            }
        }
}

+ (SetModel *)getUserInfo {
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:LOGIN_PLIST];
    
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray * keys = [NSMutableArray arrayWithArray:@[@"delay", @"ifDelay", @"infrared", @"sound", @"waves"]];

    SetModel * model = [SetModel mj_objectWithKeyValues:dic];
    for (int i =0; i<keys.count; i++) {
        
        NSString * sKey = keys[i];
        NSInteger value = [[model valueForKey:sKey] integerValue];
        
        if (i < 2 && value == 0) {
            
            [model setValue:[NSString stringWithFormat:@"%d",1000] forKey:sKey];
        } else if (i >= 2 && value == 0) {
            
            [model setValue:[NSString stringWithFormat:@"%d",48] forKey:sKey];
        }
        
    }
    
    return model;
   
}

+ (void)writeUserInfo:(NSDictionary *)userInfo {
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:LOGIN_PLIST];
    
    SetModel * model = [APPControll getUserInfo];
    if (!model) {
        [userInfo writeToFile:path atomically:YES];
        return ;
    }
    
    for (NSString * key in userInfo.allKeys) {
        
        NSString * value = userInfo[key];
        if ([key isEqualToString:@"id"]) {
            
            [model setValue:value forKey:@"uid"];

        } else {
        [model setValue:value forKey:key];
        }
    }
    
   
    
    userInfo = [model mj_keyValues];
    
    [userInfo writeToFile:path atomically:YES];
    
    NSLog(@"%@",path);
}
    
+ (NSArray *)getPropertyNamesForClass:(Class)class {
    
    unsigned int outCount = 0;
    
    NSMutableArray * ivas = [NSMutableArray array];
    Ivar * ivars = class_copyIvarList([SetModel class], &outCount);
    
    for (unsigned int i=0; i<outCount; i++) {
        
        Ivar iv = ivars[i];
        const char * ivname = ivar_getName(iv);
        
        NSString * string = [NSString stringWithUTF8String:ivname];
        string = [string componentsSeparatedByString:@"_"].lastObject;
        
        [ivas addObject:string];
        
    }
    
    return ivas;
}
    
    
+ (CGFloat)blocklyResizeWithWidth:(CGFloat)width {
 
    CGSize screenSzie = [UIApplication sharedApplication].windows.firstObject.bounds.size;
    
    CGFloat newValue = width/480.0*(screenSzie.width);
    return newValue;
}

+ (BOOL)writeUpdateSourceToFile:(NSData *)data {
    
    NSString * binPath = [[NSBundle mainBundle] pathForResource:@"sirui" ofType:@"bin"];
    
    NSData * newDate = [NSData dataWithContentsOfFile:binPath];
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:UPDATE_FILE_PATH];
    
    BOOL success = [newDate writeToFile:path atomically:YES];
    
    return success;
    
}
    
+ (NSData *)getUpdateSource {
    
//    NSString * path = [NSHomeDirectory() stringByAppendingString:UPDATE_FILE_PATH];
//    
//    NSData * data = [NSData dataWithContentsOfFile:path];

    NSString * binPath = [[NSBundle mainBundle] pathForResource:@"sirui" ofType:@"bin"];
    
    NSData * data = [NSData dataWithContentsOfFile:binPath];
    
    return data;
}

+ (NSDictionary *)getTypeDic {
    
    
    NSString  * path = [[NSBundle mainBundle] pathForResource:@"typename" ofType:@"plist"];
    
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dic;
}

+ (CGSize)getSizeOfText:(NSString *)text font:(UIFont *)font realSize:(CGSize)realSize {

    
   CGRect rect = [text boundingRectWithSize:realSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size;
}
    
@end
