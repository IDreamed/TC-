//
//  SetModel.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/6.
//  Copyright © 2017年 text. All rights reserved.
//

#import "SetModel.h"

@implementation SetModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.avatar = @"touxiang";
        self.name = @"";
        self.sex = @"0";
        self.mobile = @"";
        self.delay = @"0";
        self.ifDelay = @"0";
        self.infrared = @"0";
        self.sound = @"0";
        self.waves = @"0";
    }
    
    return self;
}
    
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"uid":@"id"
             };
}
    
@end
