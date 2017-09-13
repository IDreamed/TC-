//
//  CustomNotificationCenter.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/9.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(BOOL);



@interface CustomNotificationCenter : NSObject

///通知中心
@property (nonatomic, strong) NSNotificationCenter * center;



+ (instancetype)sharedCenter;

- (void)addObserver:(id)observer block:(BKYBlock *)block callback:(SEL)blueBlock;

- (void)removeObserver:(id)observer blockName:(NSString *)name values:(NSArray *)values;

- (void)postBluetoothValue:(NSData *)data;

- (void)addObserver:(id)observer name:(NSString *)name callback:(SEL)blueBlock object:(id)object;
- (void)removeAllNotifitionWithObserver:(id)observer;

//- (NSString *)getNotifationNameWith:(NSString *)typeName;
///发送通知
+ (void)postNotaficationWithName:(NSString *)name;

@end
