//
//  BLEControl.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

#define BLUUID @"FFE0"


@interface BLEControl : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
    
    ///蓝牙的设备管理
    @property (strong, nonatomic) CBCentralManager * manager;
    ///链接的蓝牙设备
    @property (strong, nonatomic) CBPeripheral * peripheral;
    ///搜索到的蓝牙设备
    @property (strong, nonatomic) NSMutableDictionary * peripherals;
    ///写入读取通道
    @property (strong, nonatomic) CBCharacteristic * ch;
    ///获取蓝牙控制器的单例
    + (instancetype)sharedControl;
//    ///与设备握手
//    - (void)connectDevice;
///跟新固件
- (void)updateDevice;

- (NSData *)returnUpdateDateWithCount:(NSInteger)count;
///根据point发送相关蓝牙指令
- (void)sendCMDToBluetooth:(NSArray *)values withBlockName:(NSString *)blockName;
///直接发送蓝牙指令 用于停止传感器
- (void)sendCMDToBluetooth:(NSString *)CMD;
///停止所有
- (void)stopBluetooth;
///清空蓝牙返回值缓存
- (void)clearCallbackData;
///16进制字符串转data
+ (NSData *)convertHexStrToData:(NSString *)str;
///data转16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

///更改设备名称
- (void)changeDeviceName:(NSString *)name;
///断开链接
- (void)disCoverDevice;
@end
