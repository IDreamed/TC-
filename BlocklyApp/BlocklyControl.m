//
//  BlocklyControl.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import "BlocklyControl.h"
#import "BLEControl.h"
#import "CustomNotificationCenter.h"
#import "ValueModel.h"
#import "BlockVC.h"
#import "UpdateValueModel.h"
@implementation BlocklyControl

static BlocklyControl * control;

+ (instancetype)shardControl {
    
    if (!control) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            control = [[BlocklyControl alloc] init];
            NSArray * images = @[@"bl_yuan_1",@"bl_fang_1",@"bl_sanjiao_1",@"bl_xingxing_1"];
            NSMutableDictionary * values = [NSMutableDictionary dictionary];
            for (int i=0; i<4; i++) {
                
                ValueModel * modle = [[ValueModel alloc] init];
                modle.image = images[i];
                [values setObject:modle forKey:modle.image];
            }
            control.model = [APPControll getUserInfo];
            control.values = values;
        });
        
    }
    
    return control;
}

- (void)setBlocks:(NSArray<BKYBlock *> *)blocks {
    
    self.functions = [NSMutableDictionary dictionary];
    
    NSMutableArray * CBArray = [NSMutableArray array];
    for (BKYBlock * block in blocks) {
        
        if ([block.name isEqualToString:@"function"]) {
            
            NSString * string = [block getBlockValues].firstObject;
            
            CurrentBlock * cb = [[CurrentBlock alloc] init];
            cb.rootBlock = block;
            cb.currentBlock = block.inputs[1].connectedBlock;
            cb.loopCount = 1;
            
            [self.functions setObject:cb forKey:string];
            
            
        } else if ([block.name isEqualToString:@"while_start"]) {
            
            CurrentBlock * cb = [[CurrentBlock alloc] init];
            cb.rootBlock = block;
            cb.currentBlock = block.nextBlock;
            cb.superBlock = cb;
            cb.loopCount = 1;
            self.mianTree = cb;
            
        } else if ([block.name isEqualToString:@"while"]) {
            
            CurrentBlock * cb = [[CurrentBlock alloc] init];
            cb.currentBlock = block.nextBlock;
            cb.rootBlock = block;
            cb.loopCount = 1;
            [CBArray addObject:cb];
//            [cb runCurrent];
        }
    }
    
    self.whileBlocks = CBArray;
    [self.whileBlocks makeObjectsPerformSelector:@selector(setSuperBlock:) withObject:self.mianTree];
    
    self.whileIsRun = NO;
    
//    [UpdateValueModel beginGetValue];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateValue) userInfo:nil repeats:YES];
    
    [self.mianTree runCurrent];
    [CustomHUD hidenHUD];
}

- (void)updateValue {

    [CustomNotificationCenter postNotaficationWithName:UPDATE_IN_NAME];
}

- (void)stopAllBlockTree {
    
    
    if ([self.timer isValid]) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.mianTree endRun];
    self.mianTree = nil;
    
//    [UpdateValueModel endGetValue];
    
    for (CurrentBlock * block in self.whileBlocks) {
        
        [[CustomNotificationCenter sharedCenter] removeObserver:block blockName:@"" values:@[]];
        
        [block endRun];
        
    }
    
    [self.values.allValues makeObjectsPerformSelector:@selector(setValue:) withObject:@(0)];
    
    [[self.functions allValues] makeObjectsPerformSelector:@selector(endRun)];

    self.functions = nil;
    self.whileBlocks = nil;
    
    self.whileIsRun = NO;
    self.currentWhile = nil;
}

- (void)showVlaueView:(BOOL)isShow {
    
    if (self.vc) {
        
        
        [self.vc showVlaueView:isShow];
    }
}

@end
