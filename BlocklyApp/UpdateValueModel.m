
//
//  UpdateValueModel.m
//  BlocklyApp
//
//  Created by 张 on 2017/9/6.
//  Copyright © 2017年 text. All rights reserved.
//

#import "UpdateValueModel.h"
#import "CustomNotificationCenter.h"
#import "BLEControl.h"

@implementation UpdateValueModel

static UpdateValueModel * model;

+ (instancetype)sharedValueModel {
    
    if (!model) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            model = [[UpdateValueModel alloc] init];
        });
    }
    return model;
}

- (void)dealloc {
    [[CustomNotificationCenter sharedCenter] removeAllNotifitionWithObserver:self];
}

+ (void)beginGetValue {
    
    if (!model) {
        
        [UpdateValueModel sharedValueModel];
    }
    
    NSArray * ports = @[@"IN1",@"IN2",@"IN3"];
    
    for (int i=0; i<ports.count; i++) {
        
        [[CustomNotificationCenter sharedCenter] addObserver:model name:ports[i] callback:@selector(getValueFormNotafishtion:) object:nil];
        NSInteger port = [[ports[i] componentsSeparatedByString:@"IN"].lastObject integerValue];
        
        NSString * key = [NSString stringWithFormat:GET_IN_VALUE,port,2,UPDATE_TIME];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
    }
    
}

+ (void)endGetValue {
    if (!model) {
        
        [UpdateValueModel sharedValueModel];
    }
    [[CustomNotificationCenter sharedCenter] removeAllNotifitionWithObserver:model];
    [[BLEControl sharedControl] sendCMDToBluetooth:ALL_STOP_CMD];
    model.IN1 = 0;
    model.IN2 = 0;
    model.IN3 = 0;
    
}

- (void)getValueFormNotafishtion:(NSNotification *)noti {

    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    const char * bytes = data.bytes;
    ButtonCallback  callback = *(ButtonCallback *)bytes;
    NSInteger point = callback.point;
    NSInteger cvalue = callback.value1;
    NSInteger port = [[noti.name componentsSeparatedByString:@"IN"].lastObject integerValue];
    if (point != port) {
        
        return ;
    }
    
    [model setValue:@(cvalue) forKey:noti.name];
    
}

@end
