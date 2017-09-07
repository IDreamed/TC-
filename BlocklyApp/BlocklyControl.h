//
//  BlocklyControl.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentBlock.h"
#import "RGBLightModel.h"

@class BlockVC;

@interface BlocklyControl : NSObject

///存储所有while blocktree的根结点封装
@property (strong, nonatomic) NSMutableArray * whileBlocks;
///函数数组
@property (strong, nonatomic) NSMutableDictionary * functions;
///主block树
@property (strong, nonatomic) CurrentBlock * mianTree;
///正在运行的while
@property (strong, nonatomic) CurrentBlock * currentWhile;
///while树是否在运行
@property (assign ,nonatomic) BOOL whileIsRun;

///RGB灯管全局值
@property (strong, nonatomic) RGBLightModel * light;
///蜂鸣器音阶
@property (copy, nonatomic) NSString * buzzerLevel;
///蜂鸣器时间
@property (assign, nonatomic) CGFloat buzzerTime;
///显示block的controller
@property (weak, nonatomic) BlockVC * vc;
///变量圆
@property (strong, atomic) NSDictionary * values;

@property (strong, nonatomic) SetModel * model;

///计时器开始时间
@property (strong, nonatomic) NSDate * beginTime;
///计时器结束时间
@property (strong, nonatomic) NSDate * endTime;


+ (instancetype)shardControl;

- (void)setBlocks:(NSArray<BKYBlock *>*)blocks;

- (void)stopAllBlockTree;

- (void)showVlaueView:(BOOL)isShow;

@end
