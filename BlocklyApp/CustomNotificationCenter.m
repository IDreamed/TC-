//
//  CustomNotificationCenter.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/9.
//  Copyright © 2017年 text. All rights reserved.
//

#import "CustomNotificationCenter.h"
#import "BLEControl.h"


@interface CustomNotificationCenter ()

//@property (nonatomic, strong) NSOperationQueue * queue;

//@property (nonatomic, copy) SuccessBlock currentBlock;

//@property (nonatomic,  strong) id observer;





@end

@implementation CustomNotificationCenter

static CustomNotificationCenter * center;

+ (instancetype)sharedCenter {
    
    if (!center) {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            center = [[CustomNotificationCenter alloc] init];
            center.center = [NSNotificationCenter defaultCenter];

        });
    }
    
    return center;
}



- (void)addObserver:(id)observer block:(BKYBlock *)block callback:(SEL)blueBlock {
    
    NSString * name = block.name;
    
    NSMutableArray * keys = [NSMutableArray array];
    if ([block.name isEqualToString:@"machine_two_stop"]) {
        
        for (NSString * value in [block getBlockValues]) {
            
            
            NSString * key = [self nameFromBlockTypeName:@"machine_stop" values:@[value]];
            [keys addObject:key];
        }
        
    } else if ([@[@"repetition_until1",@"repetition_until2",@"if",@"if2",@"if_else",@"if_else2",@"wait_do"] containsObject:name]) {
        
        NSArray * values = [block getBlockValues];
        
        NSMutableArray * newArray = [NSMutableArray arrayWithArray:values];
        
        if (newArray.count < 3) {
            
            NSString * newValue = [NSString stringWithFormat:@"%@%@",newArray[0],newArray[1]];
            [newArray replaceObjectAtIndex:0 withObject:newValue];
        }
        
        for (int i=0; i<newArray.count; i+=2) {
            
            NSString * value = newArray[i];
            NSString * key = [self nameFromBlockTypeName:@"while" values:@[value]];
            [keys addObject:key];
        }
        
    } else {
        
        NSString * sendKey = [self nameFromBlockTypeName:name values:[block getBlockValues]];
        [keys addObject:sendKey];
    }

    for (NSString * key in keys) {
        
        [self.center addObserver:observer selector:blueBlock name:key object:nil];

    }
    
    if (keys.count == 0) {
        
        [self runNoBluetoothBlock:block observer:observer callback:blueBlock];
    }
    
}

- (void)addObserver:(id)observer name:(NSString *)name callback:(SEL)blueBlock {
    
    [self.center addObserver:observer selector:blueBlock name:name object:self];
}

///由软件控制执行的block
- (void)runNoBluetoothBlock:(BKYBlock *)block observer:(id)observer callback:(SEL)callback {

    NSNumber * value = @(YES);
    NSNotification * noti = [[NSNotification alloc] initWithName:@"defout" object:value userInfo:@{}];
    
    [observer performSelector:callback withObject:noti];
    
    
}

- (void)removeObserver:(id)observer blockName:(NSString *)name values:(NSArray *)values {
    
    
    if ([name isEqualToString:@"while"]) {
        
        [self.center removeObserver:observer];
    }
    
    for (NSString * value in values) {
        
        NSString * key = [self nameFromBlockTypeName:name values:@[value]];
        if (key.length >0) {
            
            [self.center removeObserver:observer name:key object:nil];
        }
    }
    
//    [self.center removeObserver:observer name:key object:nil];
}

- (void)postBluetoothValue:(NSData *)data {
    
//    NSLog(@"%@",[BLEControl convertDataToHexStr:data]);

    
    NSString * key = @"";
    
    if (data.length == 9) {
        
        const void * bytes = data.bytes;
        FiveLenthCallback * six = (FiveLenthCallback *)bytes;
        
        key = [NSString stringWithFormat:NAME_HEAD,six->point];
        
        if (six->point == 0x54) {
            
            NSString * string = @"更改成功，请等待设备重启";
            if (six->success == 0x01) {
                
                [NSThread sleepForTimeInterval:1];
                [[BLEControl sharedControl] disCoverDevice];
            } else {
                string = @"更改名字失败";
            }
            [CustomHUD showText:string];
            
        } else {
           // [self.center postNotificationName:key object:self userInfo:@{@"callback":[NSValue value:&six withObjCType:@encode(SixLenthCallback)]}];

            [self.center postNotificationName:key object:self userInfo:@{@"callback":data}];
        }
        
    } else if (data.length == 10) {
        
        SixLenthCallback six;
        [data getBytes:&six length:sizeof(six)];
        
        
        
        key = [NSString stringWithFormat:NAME_HEAD,six.point];
    
        [self.center postNotificationName:key object:nil userInfo:@{@"callback":data}];
        
    } else if (data.length == 11) {
        
        eightLenthCallback six;
        [data getBytes:&six length:sizeof(six)];
        key = [NSString stringWithFormat:NAME_HEAD,six.point];

        
        
        [self.center postNotificationName:key object:nil userInfo:@{@"callback":data}];
        
        
    } else if (data.length == 12) {
        
        ButtonCallback six;
        [data getBytes:&six length:sizeof(six)];
    

        key = [NSString stringWithFormat:NAME_HEAD,six.point];
        
        [self.center postNotificationName:key object:nil userInfo:@{@"callback":data}];
    }
    
}

- (NSString *)nameFromBlockTypeName:(NSString *)name values:(NSArray *)values {
    
    NSInteger point = 0;
    if ([name isEqualToString:@"while"]) {
        
        NSString * value = values.lastObject;
        point = [[value componentsSeparatedByString:@"IN"].lastObject integerValue];
        
    } else if ([@[@"machine_speed_direction",@"machine_stop"] containsObject:name]) {
        NSString * pontStr = values[0];
        point = [[pontStr componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
    } else if ([@[@"fan_stop",@"fan_speed"] containsObject:name]) {
        NSString * portStr = values[0];
        point = [[portStr componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
    } else if ([@[@"light_on_off",@"light_caution_on_off",@"light_color",@"highlight_level",@"highlight_on_off",@"light1",@"light2"] containsObject:name]) {
        
        NSString * portStr = values[0];
        point = [[portStr componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        
    } else if ([@[@"daily_words",@"action",@"animal_sound",@"transport_sound",@"own_sound",@"buzzer_on_off",@"buzzer_level"] containsObject:name]) {

        NSString * portStr = values[0];
        point = [[portStr componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

    
    } else if ([@[@"port_on_off",@"port_type",@"port_in",@"port_out"] containsObject:name]) {
    
        NSString * portStr = values[0];
        point = [[portStr componentsSeparatedByString:@"IN"].lastObject integerValue];
        if (point == 0) {
            
            point = [[portStr componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
            
        }
        

    }
    
    if (point != 0) {
        
        NSString * key = [NSString stringWithFormat:@"Point%02lx",(long)point];
        
        return key;
    } else {
        
        return @"";
    }
    
    
}

- (BOOL)successWithBluetoothValue:(NSString *)name {
    
    NSString * str = [name substringWithRange:NSMakeRange(15, 1)];
    
    if ([str isEqualToString:@"1"]) {
    
        return YES;
        
    } else if ([str isEqualToString:@"f"]) {
        
        return  NO;
    } else {
        
        return NO;
    }
        
    
}

@end
