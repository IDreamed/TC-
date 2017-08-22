//
//  BLEControl.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import "BLEControl.h"
#import "CustomHUD.h"
#import "APPControll.h"
#import "NSData+Healper.h"
#import "CurrentBlock.h"
#import "CustomNotificationCenter.h"
#import "BlocklyControl.h"

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

@interface BLEControl () <CBCentralManagerDelegate, CBPeripheralDelegate>

///更新固件的数据帧数
@property (assign, nonatomic) NSInteger updateCount;
///存放每帧的数组
@property (strong, nonatomic) NSMutableArray * updatas;
///当前发送中的数据帧
@property (strong, nonatomic) NSData * currentData;
///蓝牙交互的模式 update位更新固件
@property (copy, nonatomic) NSString * type;
///更新固件用线程 20ms间隔
@property (strong, nonatomic) NSThread * thread;
///
@property (assign, nonatomic) BOOL isPost;

///返回的data数据
@property (strong, nonatomic) NSMutableData * callbackData;

///设置5 6端口的发送字段
@property (strong, nonatomic) NSMutableDictionary * portSource;


@end

@implementation BLEControl

static BLEControl * control;
+ (instancetype)sharedControl {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!control) {
            control = [[BLEControl alloc] init];
            control.peripherals = [NSMutableDictionary dictionary];
        }
        
    });
    
    return control;
}

- (NSMutableDictionary *)portSource {
    
    if (!_portSource) {
        _portSource = [NSMutableDictionary dictionary];
    }
    
    return _portSource;
}

- (void)dealloc {
    
}

- (NSMutableData *)callbackData {
    
    if (!_callbackData) {
        
        _callbackData = [NSMutableData data];
    }
    return _callbackData;
}

- (void)setManager:(CBCentralManager *)manager {
    
    _manager = manager;
    _manager.delegate = self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral {
    
    _peripheral = peripheral;
    _peripheral.delegate = self;
    if (peripheral && self.manager) {
        
        [self readPeripheral];
    }
}

- (void)readPeripheral {
    
    [self.peripheral discoverServices:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            [CustomHUD showText:@"蓝牙未开始，请重试"]; //蓝牙未开启
            self.manager = nil;
            
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            
                            [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            
//            [self.manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    [CustomHUD showText:@"蓝牙连接已断开"];
    if (self.peripheral == peripheral) {
        
        self.peripheral = nil;
        self.ch = nil;
        [NSThread sleepForTimeInterval:0.5];
        
        [self.manager connectPeripheral:peripheral options:nil];
    }
    self.peripheral = nil;
    self.ch = nil;
}

//获取服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        
        NSLog(@"%@",error);
        return ;
    }
    
    for (CBService * s in peripheral.services) {
        
        [peripheral discoverCharacteristics:nil forService:s];
    }
}
//获取
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        
        NSLog(@"%@", error);
        return ;
    }
    
    for (CBCharacteristic * ch in service.characteristics) {
        //读取descript
        //        [peripheral discoverDescriptorsForCharacteristic:ch];
        
        
        
        
        if ([ch.UUID isEqual:[CBUUID UUIDWithString:@"ffe1"]]) {
            
            self.ch = ch;
            
            [peripheral setNotifyValue:YES forCharacteristic:ch];
        }
        
    }
}

//订阅成功回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"change");
    //读取value
    [peripheral readValueForCharacteristic:characteristic];
    
}


//读取到的character值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        
        NSLog(@"error");
        return;
    }
    
    
    NSData * data = characteristic.value;
    [self.callbackData appendData:data];
    [self searchCMD];
    
}

- (void)searchCMD {
    
    NSString * str = [BLEControl convertDataToHexStr:self.callbackData];
    NSRange range = [str rangeOfString:@"c56a"];
    
    if (range.location != NSNotFound && range.length != 0 && str.length > range.location+4) {
        
        NSString * lenthChar = [str substringWithRange:NSMakeRange(range.location+4, 4)];
        const char * buffer = [lenthChar UTF8String];
        NSInteger lenth = strtol(buffer, NULL, 16);

        if (str.length >= (4+lenth)*2) {
            
            [self postDataWithRange:range lenth:lenth];
            [self searchCMD];
        }
        
        
    }

}

- (void)postDataWithRange:(NSRange)range lenth:(NSInteger)lenth {
    
    
    NSString * str = [BLEControl convertDataToHexStr:self.callbackData];
    
    
        NSRange dataRange = NSMakeRange(range.location/2, 4+lenth);
        NSData * subData = [self.callbackData subdataWithRange:dataRange];
        NSLog(@"post %@",[BLEControl convertDataToHexStr:subData]);
        
        [self.callbackData replaceBytesInRange:NSMakeRange(0, range.location/2+lenth+4) withBytes:NULL length:0];
        
        if (subData.length == 14) {
            str = [BLEControl convertDataToHexStr:subData];
            [self postUpdateCallback:str];
            
        }  else {
            
            [NSThread detachNewThreadSelector:@selector(threadPostData:) toTarget:self withObject:subData];
        }
    
}

- (void)threadPostData:(NSData *)data {
    
    [[CustomNotificationCenter sharedCenter] postBluetoothValue:data];
    [NSThread exit];
}


//停止扫描并断开连接
-(void)disconnectPeripheral:(CBCentralManager *)centralManager
                 peripheral:(CBPeripheral *)peripheral{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}



#pragma mark -------与设备交互--------

#pragma mark 固件更新
- (void)updateDevice {
    
    
    if (self.manager && self.peripheral && self.ch) {
        
        self.updatas = [NSMutableArray array];
        NSData * data = [APPControll getUpdateSource];
        
        self.updateCount = (data.length + 512) / 512;
        
        for (int i=0; i<self.updateCount; i++) {
            
            NSData * data = [self returnUpdateDateWithCount:i];
            if (i == 0) {
                
                self.currentData = data;
            }
            
            [self.updatas addObject:data];
        }
        
        
        [self writUpdateData];
        [CustomHUD showwithTextDailog:@"上传文件中，请稍等"];
    }
    
    
}
- (void)writUpdateData {
    
    
//    [self.peripheral writeValue:self.currentData forCharacteristic:self.ch type:CBCharacteristicWriteWithResponse];
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadUpdate) object:nil];
    [self.thread start];
}

- (void)threadUpdate {
    
    
    NSInteger count = (self.currentData.length + 19)/20;
    
    for (int i=0; i<count; i++) {
        
        [self postUpdateWithCount:i data:self.currentData];
        
        [NSThread sleepForTimeInterval:0.01];
        
    }
    
//    [NSThread exit];
//    self.thread = nil;
}

- (void)postUpdateWithCount:(NSInteger)count data:(NSData *)data {
    
    
    NSInteger newCount = (count + 1) * 20;
    
    NSInteger location = count * 20;
    NSInteger lenth = 20;
    
    if (data.length < newCount) {
        
        lenth = data.length - location;
        
    }
    NSData * subData = [data subdataWithRange:NSMakeRange(location, lenth)];
    
    [self.peripheral writeValue:subData forCharacteristic:self.ch type:CBCharacteristicWriteWithoutResponse];
}

- (void)postUpdateCallback:(NSString *)string {
    
    if (string.length < 16) {
     
        return ;
    }
    
    NSString * subStr = [string substringToIndex:14];
    
    if (![subStr isEqualToString:@"c56a000a140007"]) {
        
        return ;
    }
    
    subStr = [string substringWithRange:NSMakeRange(15, 1)];
        if ([subStr isEqualToString:@"1"]) {
        
        NSInteger index = [self.updatas indexOfObject:self.currentData];
        if (index+1 < self.updatas.count) {
            
            self.currentData = self.updatas[index+1];
            [self writUpdateData];
        } else {
            ///上传成功
            [CustomHUD showText:@"设备升级中请稍等"];
            
        }
    } else if ([subStr isEqualToString:@"f"]) {
        
        [self writUpdateData];
    }
    
}

//- (void)writeUpdateCallback:(NSError *)error {
//    
//    
//    if (error) {
//        NSLog(@"error");
//        
//        [self postUpdateData:self.currentData];
//    } else {
//        
//        self.currentIndex += 1;
//        if (self.currentIndex < (self.currentData.length+20)/20) {
//            
//            [self postUpdateData:self.currentData];
//            
//        }
//    }
//}

//拼接更新数据帧
- (NSData *)returnUpdateDateWithCount:(NSInteger)count {
    
    NSMutableString * heardString = [NSMutableString stringWithFormat:@"c56a020a13020753"];
    
    if (count == 0) {
        
        [heardString appendFormat:@"a1"];
    } else if (count == self.updateCount-1) {
        [heardString appendString:@"a3"];
    } else {
        [heardString appendString:@"a2"];
    }
    [heardString appendFormat:@"%04lx",(long)self.updateCount];
    [heardString appendFormat:@"%04lx",(long)count];
    NSData * heardData = [NSData hexToBytes:heardString];
    
    NSMutableData * data = [NSMutableData dataWithData:heardData];
    NSMutableData * source = [NSMutableData dataWithData:[APPControll getUpdateSource]];
    
    NSInteger lenth = 512;
    
    NSInteger newCount = (count+1) * lenth;
    if (source.length <newCount) {
        
        NSInteger s = newCount - data.length;
        NSMutableData * sdata = [[NSMutableData alloc] initWithLength:s];
        [source appendData:sdata];
    }
    
    
    NSRange range = NSMakeRange((count)*lenth, lenth);
    NSData * subData = [source subdataWithRange:range];
    
    NSData * subSum = [subData returnSumValue];
    
    [data appendData:subData];
    [data appendData:subSum];
    
    
    return data;
}



- (void)sendBluetoothWithCurrentBlock:(BKYBlock *)block {
    
    
    
    //根据type name和参数拼接蓝牙的发送数据  并添加监听
    NSArray * tyArray = @[@"repetition_until1",@"repetition_until2",@"if",@"if2",@"if_else",@"if_else2",@"wait_do"];
    
    NSDictionary * keys = [self returnOnRobot:block.name blockValues:[block getBlockValues]];

    if ([tyArray containsObject:block.name]) {
        
        keys = [self returnOnRobot:@"while" blockValues:[block getBlockValues]];
    }
    
    for (NSNumber * key in keys.allKeys) {
        
        if ([key integerValue] >= 40) {
            
            NSInteger point = [key integerValue] /10;
            NSInteger value = [key integerValue] % 10 ? MONI: SHUZI;
            NSString * send = [NSString stringWithFormat:SET_POINT,(long)point,(long)value];
            NSString * name = [NSString stringWithFormat:NAME_HEAD,(int)point];
            [self.portSource setObject:keys[key] forKey:name];
            [[CustomNotificationCenter sharedCenter] addObserver:self name:name callback:@selector(setPointCallback:)];
            [self.peripheral writeValue:[BLEControl convertHexStrToData:send] forCharacteristic:self.ch type:CBCharacteristicWriteWithoutResponse];
            
        } else {
                
                [self.peripheral writeValue:[BLEControl convertHexStrToData:keys[key]] forCharacteristic:self.ch type:CBCharacteristicWriteWithResponse];
                NSLog(@"thread:%@ send: %@", key,[NSThread currentThread]);
                
            }
            
    }
    
//        [self.peripheral writeValue:[BLEControl convertHexStrToData:sendKey] forCharacteristic:self.ch type:CBCharacteristicWriteWithResponse];
    
}

- (void)setPointCallback:(NSNotification *)noti {

    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
        
    [[CustomNotificationCenter sharedCenter].center removeObserver:self name:noti.name object:[CustomNotificationCenter sharedCenter]];
    
    const void * bytes = data.bytes;
    FiveLenthCallback * five = (FiveLenthCallback *)bytes;

    NSLog(@"%d  %d ",five->success, five->point);
    
    if (five->success == 0x01) {
        NSString * send = self.portSource[noti.name];

        ///只设置端口
        if (send.length > 0) {
            [self.peripheral writeValue:[BLEControl convertHexStrToData:send] forCharacteristic:self.ch type:CBCharacteristicWriteWithoutResponse];
            
        }
        
    } else {
        
        [CustomHUD showText:@"设置端口失败"];
        [[BlocklyControl shardControl] stopAllBlockTree];
    }
    
}

/// 获取要打开的传感器指令
- (NSDictionary *)returnOnRobot:(NSString *)blockName blockValues:(NSArray *)blockValues {
    
    NSMutableArray * newValues = [NSMutableArray arrayWithArray:blockValues];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSDictionary * types = [APPControll getTypeDic];
    NSString * sendKey = types[blockName];
    
    if (sendKey.length == 0) {
        return dict;
    }
    
    if ([blockName isEqualToString:@"while"]) {
        
        if (newValues.count < 3) {
            
            NSString * value = [NSString stringWithFormat:@"%@%@",blockValues[0],blockValues[1]];
            [newValues replaceObjectAtIndex:0 withObject:value];
        }
        
        for (int i=0; i<newValues.count; i+=2) {
            
            NSString * value = newValues[i];
            NSInteger point = [[value componentsSeparatedByString:@"IN"].lastObject integerValue];
            
            if ([value containsString:@"yanse"]) {
                
                sendKey = [NSString stringWithFormat:COLOR,point];
            } else {
                sendKey = [NSString stringWithFormat:WAVES,point];
            }

            [dict setObject:sendKey forKey:@(point)];
        }
    }
    
    if ([blockName isEqualToString:@"machine_speed_direction"]) {
        
        NSInteger point = [[blockValues[0] componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
        
        NSInteger fangxiang = [blockValues[2] isEqualToString:@"dj_shunshizhen_1"];
        NSInteger sudu = [blockValues[1] integerValue]-1;
        NSInteger min = 0;
        NSArray * times = [blockValues[3] componentsSeparatedByString:@"."];
        NSInteger s = [times[0] integerValue];
        NSInteger ms = [times[1] integerValue];
        
        sendKey = [NSString stringWithFormat:MACHINE_HEAD,point,fangxiang,sudu,min,s,ms];
        
        if (point == 5 || point == 6 || point == 4) {
            point = point * 10 + 1;///数字信号
//            point = point * 10  ///模拟信号
        }
        
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"machine_stop"]) {
        
        NSInteger point = [[blockValues[0] componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
        
        sendKey = [NSString stringWithFormat:sendKey,point];
        if (point == 5 || point == 6 || point == 4) {
            point = point * 10 + 1;///数字信号
            //            point = point * 10  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"machine_two_stop"]) {
        
        for (int i=0; i<blockValues.count; i++) {
            
            NSInteger  point = [[blockValues[i] componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

            sendKey = [NSString stringWithFormat:sendKey,point];
            if (point == 5 || point == 6 || point == 4) {
                point = point * 10 + 1;///数字信号
                //            point = point * 10  ///模拟信号
            }
            [dict setObject:sendKey forKey:@(point)];
        }
        
    }
    
    if ([blockName isEqualToString:@"fan_stop"]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
        
        sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,0];
        if (point == 5 || point == 6) {
//            point = point * 10 + 1;///数字信号
            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
        
    }
    if ([blockName isEqualToString:@"fan_speed"]) {
        
        NSInteger speed = [blockValues.lastObject integerValue] > 0? [blockValues.lastObject integerValue] : [blockValues.lastObject integerValue] + 1;
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,speed];
        if (point == 5 || point == 6) {
            //            point = point * 10 + 1;///数字信号
            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"light_on_off"]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
        
        if ([blockValues.lastObject isEqualToString:@"dg_dengliang_1"]) {
            
            if ([BlocklyControl shardControl].light.RGBColor) {
                
              //  NSString * color = [self getColorRGBWithColorName:[BlocklyControl shardControl].light.RGBColor];
                
              //  sendKey = [NSString stringWithFormat:sendKey,point,color];
                
                sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,99];
                
                if (point == 5 || point == 6) {
                    //            point = point * 10 + 1;///数字信号
                    point = point * 10;  ///模拟信号
                }
                [dict setObject:sendKey forKey:@(point)];
            } else {
                
            //    sendKey = [NSString stringWithFormat:sendKey,point,@"ffffff"];
                sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,0];

                if (point == 5 || point == 6) {
                    //            point = point * 10 + 1;///数字信号
                    point = point * 10;  ///模拟信号
                }
                [dict setObject:sendKey forKey:@(point)];
            }

        } else {
            
           // sendKey = [NSString stringWithFormat:sendKey,point,@"000000"];
            sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,0];

            if (point == 5 || point == 6) {
                //            point = point * 10 + 1;///数字信号
                point = point * 10;  ///模拟信号
            }
            [dict setObject:sendKey forKey:@(point)];
        }
        
        
    }
    
    if ([blockName isEqualToString:@"light_color"]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSString * color = [self getColorRGBWithColorName:blockValues.lastObject];
        sendKey = [NSString stringWithFormat:sendKey,point,color];
        if (point == 5 || point == 6) {
            //            point = point * 10 + 1;///数字信号
            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([@[@"highlight_on_off",@"light2"] containsObject:blockName]) {
     
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSInteger value = 0;
        if ([blockValues.lastObject isEqualToString:@"dg_dengliang_1"]) {
            
            value = [BlocklyControl shardControl].light.highlightLevel;
        }
        
        sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,value];
        if (point == 5 || point == 6) {
            //            point = point * 10 + 1;///数字信号
            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    
    if ([@[@"highlight_level",@"light1"] containsObject:blockName]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSInteger value = [blockValues.lastObject integerValue];
        
        if ([blockName isEqualToString:@"light1"]) {
            
            value = value * 20;

        }
        
        value = value > 0? value-1 : 0;
    
        sendKey = [NSString stringWithFormat:LIGHT_LIVE,point,value];
        if (point == 5 || point == 6) {
            //            point = point * 10 + 1;///数字信号
            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"daily_words"]) {
        NSArray * vales = @[@"bibibibibi",@"bling",@"duang",@"生日歌",@"数码声",@"小号声",@"旋律"];
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSInteger soundIndex = 0;
        NSInteger index = [vales indexOfObject:blockValues[1]];
        soundIndex = index + 22;
        sendKey = [NSString stringWithFormat:sendKey,point,soundIndex];
        if (point == 5 || point == 6) {
            point = point * 10 + 1;///数字信号
//            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    if ([blockName isEqualToString:@"action"]) {
        NSArray * vales = @[@"wuwuwu",@"打呼噜",@"打雷",@"东西掉地上",@"欢呼",@"口哨",@"冒泡",@"亲吻",@"跳水"];
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSInteger index = [vales indexOfObject:blockValues[1]];
        NSInteger soundIndex = index + 13;
        sendKey = [NSString stringWithFormat:sendKey,point,soundIndex];
        if (point == 5 || point == 6) {
            point = point * 10 + 1;///数字信号
            //            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];

    }
    
    if ([blockName isEqualToString:@"animal_sound"]) {
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSArray * vales = @[@"狗啃骨头",@"狗狂吠",@"恐龙",@"猫叫",@"鸟叫",@"青蛙叫"];
        NSInteger index = [vales indexOfObject:blockValues[1]];
        NSInteger soundIndex = index + 1;
        sendKey = [NSString stringWithFormat:sendKey,point,soundIndex];
        if (point == 5 || point == 6) {
            point = point * 10 + 1;///数字信号
            //            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"transport_sound"]) {
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        NSArray * values = @[@"车鸣笛",@"船鸣笛",@"飞机起飞",@"火车鸣笛",@"警车鸣笛",@"拖拉机"];
        NSInteger index = [values indexOfObject:blockValues[1]];
        NSInteger soundIndex = index + 7;

        sendKey = [NSString stringWithFormat:sendKey,point,soundIndex];
        if (point == 5 || point == 6) {
            point = point * 10 + 1;///数字信号
            //            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"buzzer_on_off"]) {
        

        if ([blockValues.firstObject isEqualToString:@"kaishi_yousheng7"]) {
            NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

            if ([[BlocklyControl shardControl].buzzerLevel integerValue] !=0 ) {
                
                sendKey = [NSString stringWithFormat:sendKey,point,[[BlocklyControl shardControl].buzzerLevel integerValue]];
            } else {
                
                sendKey = [NSString stringWithFormat:sendKey,point,1];
            }
            if (point == 5 || point == 6) {
                point = point * 10 + 1;///数字信号
                //            point = point * 10;  ///模拟信号
            }
            [dict setObject:sendKey forKey:@(point)];

            
        } else {
            
            NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

            sendKey = [NSString stringWithFormat:sendKey,point,0];
            if (point == 5 || point == 6) {
                point = point * 10 + 1;///数字信号
                //            point = point * 10;  ///模拟信号
            }
            [dict setObject:sendKey forKey:@(point)];
        }
        
    }
    
    if ([blockName isEqualToString:@"buzzer_level"]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;

        
        NSArray * yins = @[@"do",@"re",@"mi",@"fa",@"so",@"la",@"si",@"Do"];
        NSInteger level = [yins indexOfObject:blockValues.firstObject];
        
        sendKey = [NSString stringWithFormat:sendKey,point,level];
        if (point == 5 || point == 6) {
            point = point * 10 + 1;///数字信号
            //            point = point * 10;  ///模拟信号
        }
        [dict setObject:sendKey forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"port_on_off"]) {
        
        
    }
    
    if ([blockName isEqualToString:@"port_type"]) {
        
        NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
        
        BOOL isShuzi = [blockValues[1] isEqualToString:@"数字"];
        
        point = point * 10 + isShuzi;
        
        [dict setObject:@"" forKey:@(point)];
    }
    
    if ([blockName isEqualToString:@"port_out"]) {
     
         NSInteger point = [[blockValues.firstObject componentsSeparatedByString:@"OUT"].lastObject integerValue] + 3;
    }
    
    if ([blockName isEqualToString:@"port_in"]) {
        
        
    }
    
    return dict;
}

- (NSString *)getColorRGBWithColorName:(NSString *)name {
    
    NSArray * array = @[@"gj_yanse_bai_1",@"gj_yanse_hong_1",@"gj_yanse_cheng_1",@"gj_yanse_lan_1",@"gj_yanse_lv_1",@"gj_yanse_pin_1",@"gj_yanse_qing_1"];
    
    if ([name containsString:@"|"]) {
        
        name = [name componentsSeparatedByString:@"|"].lastObject;
    }
    
    NSString * color = @"ffffff";
    
    NSInteger index = [array indexOfObject:name];
    
    switch (index) {
        case 0: {
            
            color = COLOR_WHITE;
            break;
        }
        case 1: {
            
            color = COLOR_RED;
            break;
        }
        case 2: {
            
            color = COLOR_ORANGE;
            break;
        }
        case 3: {
            
            color = COLOR_BLUE;
            break;
        }
        case 4: {
            
            color = COLOR_GREEN;
            break;
        }
        case 5: {
            
            color = COLOR_PURPLE;
            break;
        }
        case 6: {
            
            color = COLOR_CYAN;
            break;
        }
        default:
            break;
    }
    
    
    return color;
}

- (void)sendCMDToBluetooth:(NSString *)CMD {
    
    if (self.peripheral && self.ch) {
        
        [self.peripheral writeValue:[BLEControl convertHexStrToData:CMD] forCharacteristic:self.ch type:CBCharacteristicWriteWithResponse];
    }
}
    
- (void)stopBluetooth {
    
    if (self.peripheral) {
        
        [self.peripheral writeValue:[BLEControl convertHexStrToData:ALL_STOP_CMD] forCharacteristic:self.ch type:CBCharacteristicWriteWithResponse];
    }
}

- (void)disCoverDevice {
    
    if (self.peripheral && self.ch) {
        
        [self.manager stopScan];
        [self.manager cancelPeripheralConnection:self.peripheral];
        self.peripheral = nil;
        self.ch = nil;
    }
}

- (void)clearCallbackData {
    
    if (self.callbackData) {
        
        [self.callbackData setLength:0];
    }
}

- (void)changeDeviceName:(NSString *)name {
    
//    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)name,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    
    NSData * urf8 = [name dataUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger lenth = urf8.length+1;
    NSInteger cmdLenth = lenth + 4;
    
    NSString * utf8Str = [BLEControl convertDataToHexStr:urf8];
    
    NSString * sendStr = [NSString stringWithFormat:@"c56a%04lx15%04lx54%@",(long)cmdLenth,(long)lenth,utf8Str];
    NSData * postData = [BLEControl convertHexStrToData:sendStr];
    self.currentData = postData;
    [self writUpdateData];
}

@end
