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

///将用户名和密码写入本地的用户信息表
+ (void)writeUserId:(NSString *)userId password:(NSString *)password;
///获取本地存储的用户名和密码
+ (NSArray *)getUserIdAndPassword;
///注册监听键盘弹出弹入的方法
+ (void)registForKeybordNotificationWithObserver:(id)observer showAction:(SEL)showAction hidenAction:(SEL)hidenAction;
///移除对键盘的监听事件
+ (void)removeKeybordNotificationWithObserver:(id)observer;
///判断字符串是否是手机号
+ (BOOL)valiMobile:(NSString *)mobile;
///获取用户信息表
+ (SetModel *)getUserInfo;
///将用户信息表写入本地
+ (void)writeUserInfo:(NSDictionary *)userInfo;
///获取对象种所有属性名称数组
+ (NSArray *)getPropertyNamesForClass:(Class)class;
///对应设计稿计算在屏幕上实际长度
+ (CGFloat)blocklyResizeWithWidth:(CGFloat)width;
///将硬件更新包写入本地 未完成
+ (BOOL)writeUpdateSourceToFile:(NSData *)data;
///获取本地的硬件更新包
+ (NSData *)getUpdateSource;
///获取硬件指令字典 目前部分使用 以后替换为宏命令
+ (NSDictionary *)getTypeDic;
///获取字符串所占大小
+ (CGSize)getSizeOfText:(NSString *)text font:(UIFont *)font realSize:(CGSize)realSize;
    
@end
