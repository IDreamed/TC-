//
//  CurrentBlock.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import "CurrentBlock.h"
#import "CustomNotificationCenter.h"
#import "BlocklyControl.h"
#import "BLEControl.h"
#import "ValueModel.h"

@interface CurrentBlock ()

///执行当前block树的线程
@property (strong, nonatomic) NSThread * thread;
///线程控制辅助
@property (strong, nonatomic) NSCondition * condition;
///线程终止判断辅助
@property (strong, nonatomic) NSCondition * threadCon;
@property (assign, nonatomic) BOOL threadEnd;


//判断辅助 判断第一个条件是否满足 0 未收到通知 1 fales 2 true
@property (assign, nonatomic) NSInteger firstTrue;
//判断辅助 第二个条件是否满足
@property (assign, nonatomic) NSInteger sectionTrue;
//判断辅助 yes = and  no = or
@property (assign, nonatomic) BOOL isAnd;

//延迟时间和传感器数据判断
///blockly延迟时间
@property (assign, nonatomic) CGFloat delay;
///if延迟时间
@property (assign, nonatomic) CGFloat ifDelay;
///声控触发条件
@property (assign, nonatomic) NSInteger sound;
///红外线触发条件
@property (assign, nonatomic) NSInteger infrared;
///超声波触发条件
@property (assign, nonatomic) NSInteger waves;

@property (assign, nonatomic) NSInteger color;

@property (assign, nonatomic) NSInteger colorTwo;

@property (copy, nonatomic) NSMutableArray * stopTwo;



@end

@implementation CurrentBlock

- (void)dealloc {
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        SetModel * model = [BlocklyControl shardControl].model;
        self.delay = [model.delay integerValue]/1000.0;
        self.ifDelay = [model.ifDelay integerValue]/1000.0;
        self.infrared = [model.infrared integerValue];
        self.waves = [model.waves integerValue];
        self.sound = [model.sound integerValue];
    }
    
    return self;
}
- (NSMutableArray *)stopTwo {
    
    if (!_stopTwo) {
        _stopTwo = [NSMutableArray array];
    }
    
    return _stopTwo;
}

- (void)setCurrentBlock:(BKYBlock *)currentBlock {
    
    _currentBlock = currentBlock;
    
    [self coffBlock];
    
}

- (void)setRootBlock:(BKYBlock *)rootBlock {
    
    _rootBlock = rootBlock;
    self.threadEnd = NO;
    if ([rootBlock.name isEqualToString:@"while"]) {
        
        if (self.currentBlock == nil) {
            
            self.currentBlock = self.rootBlock.nextBlock;
        }
        //        self.loopCount = 1;
        [self coffNotifition];
        
    }
}

- (NSCondition *)condition {
    
    if (!_condition) {
        
        _condition = [[NSCondition alloc] init];
    }
    return  _condition;
}
- (NSCondition *)threadCon {
    
    if (!_threadCon) {
        
        _threadCon = [[NSCondition alloc] init];
    }
    
    return _threadCon;
}

- (CurrentBlock *)DOCurrent {
    
    if (!_DOCurrent) {
        _DOCurrent = [[CurrentBlock alloc] init];
    }
    return _DOCurrent;
}
- (CurrentBlock *)ELSECurrent {
    
    if (!_ELSECurrent) {
        _ELSECurrent = [[CurrentBlock alloc] init];
    }
    return _ELSECurrent;
}

- (void)coffBlock {
    self.firstTrue = 1;
    self.sectionTrue = 1;
    self.currentName = self.currentBlock.name;
    if (self.currentBlock.inputs.count > 1) {
        
        for (int i=1; i<self.currentBlock.inputs.count; i+=2) {
            
            BKYInput * input = self.currentBlock.inputs[i];
            
            if ([input.name isEqualToString:@"DO"]) {
                
                self.DOCurrent = [[CurrentBlock alloc] init];
                self.DOCurrent.currentBlock = input.connectedBlock;
                self.DOCurrent.rootBlock = self.currentBlock;
                self.DOCurrent.superBlock = self;
                self.DOCurrent.loopCount = 1;
            }
            
            if ([input.name isEqualToString:@"ELSE"]) {
                
                self.ELSECurrent = [[CurrentBlock alloc] init];
                self.ELSECurrent.rootBlock = self.currentBlock;
                self.ELSECurrent.currentBlock = input.connectedBlock;
                self.ELSECurrent.superBlock = self;
                self.ELSECurrent.loopCount = 1;
            }
            
        }
    }
    
    //    if ([self.currentBlock.name isEqualToString:@"do_function"]) {
    //
    //        NSString * name = [self.currentBlock getBlockValues].firstObject;
    //
    //        BlocklyControl * control = [BlocklyControl shardControl];
    //
    //        if (self.superBlock && control.functions[name]) {
    //
    //            self.currentName = self.currentBlock.name;
    //            self.currentBlock = control.functions[name];
    //
    //        }
    //    }
    
    //重复的block
    [self selfCoffLoopBlock];
}

- (void)selfCoffLoopBlock {
    
    NSArray * array = @[@"always_repeat",@"repetition_num",@"repetition_until1",@"repetition_until2",@"variable_repetition_num",@"variable_repetition"];
    
    NSInteger index = [array indexOfObject:self.currentBlock.name];
    
    switch (index) {
        case 0: {
            
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 1: {
            
            self.DOCurrent.loopCount = [[self.currentBlock getBlockValues].firstObject integerValue];
            
            break;
        }
        case 2: {
            
            
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 3: {
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 4: {
            
            NSArray * values = [self.currentBlock getBlockValues];
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            self.DOCurrent.loopCount = (int)model.value;
            
            break;
        }case 5: {
            
            self.DOCurrent.loopCount = 10000;
            break;
        }
        default:
            break;
    }
    
    
}

- (void)coffNotifition {
    
    ///查看block具体数据注册相对的通知
    
    [[CustomNotificationCenter sharedCenter] addObserver:self block:self.rootBlock callback:@selector(whileBegin:)];
    
    [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:self.rootBlock];
    
}

- (void)whileBegin:(NSNotification *)noti {
    
    
    //    [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:noti.name];
    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    const char * bytes = data.bytes;
    ButtonCallback  callback = *(ButtonCallback *)bytes;
    NSInteger point = callback.point;
    NSInteger cvalue = callback.value1;
    NSArray * values = [self.rootBlock getBlockValues];
    
    
    
    if ([values[0] containsString:@"亮度"]) {
        
        if (callback.lenth2 != 8) {
            
            return ;
        }
        
        NSString * blockValue = [self.rootBlock getBlockValues].firstObject;
        NSInteger rValue = [[blockValue componentsSeparatedByString:@"%"].lastObject integerValue];
        rValue = rValue / 100.0 * 256;
        
        if (cvalue > rValue) {
            
            [self runWhileBlock];
        }
        
        
    }
    if ([values[0] isEqualToString:@"红外线"]) {
        
        if (callback.lenth2 != 8) {
            
            return ;
        }
        
        if (cvalue > self.infrared) {
            
            [self runWhileBlock];
            
        }
        
    }
    
    if ([values[0] isEqualToString:@"有压力"]) {
        
        if (callback.lenth2 != 8) {
            
            return ;
        }
        
        if (cvalue > self.infrared) {
            
            [self runWhileBlock];
            
        }
    }
    
    
    if (point == 3 && callback.value1 > 40) {
        [self runWhileBlock];
        
    }
    
    if (point == 7 && callback.value1 == 1) {
        
        [self runWhileBlock];
    }
    
    if (point == 8) {
        
        if (callback.lenth2 != 8) {
            
            return ;
        }
        if (callback.value2 == 00) {
            
            NSInteger value = callback.value1 * 16 + callback.value2;
            
            if (value < self.waves) {
                
                [self runWhileBlock];
            }
            
#warning 判断距离是多少触发
            
        } else {
            
            NSInteger color = callback.value1;
            NSString * colorStr = [self.currentBlock getBlockValues].firstObject;
            NSArray * colors = @[@"|gj_yanse_bai_1",
                                 @"|gj_yanse_hei_1",
                                 @"|gj_yanse_hong_1",
                                 @"|gj_yanse_lv_1",
                                 @"|gj_yanse_lan_1",
                                 @"|gj_yanse_cheng_1"];
            NSInteger forcolor = [colors indexOfObject:colorStr];
            if (color == forcolor) {
                
                [self runWhileBlock];
            }
            
            
#warning 对比颜色的值
        }
    }
    
    
}

- (void)runWhileBlock {
    
    [self.superBlock endRun];
    if (![BlocklyControl shardControl].whileIsRun) {
        
        NSLog(@"runwhile new");
        [BlocklyControl shardControl].whileIsRun = YES;
        [BlocklyControl shardControl].currentWhile = self;
        
        self.currentBlock = self.rootBlock.nextBlock;
        self.loopCount = 1;
        [self runCurrent];
    } else {
        
        if ([BlocklyControl shardControl].currentWhile == self) {
            
            NSLog(@"runwhile self");
            return ;
        }
        
        NSLog(@"tunwhile newnew");
        [[BlocklyControl shardControl].currentWhile endRun];
        [BlocklyControl shardControl].currentWhile = self;
        
        self.currentBlock = self.rootBlock.nextBlock;
        self.loopCount = 1;
        
        [self runCurrent];
        
    }
    
}

- (void)runCurrent {
    
    if (!self.thread) {
        
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(beginRun) object:nil];
        NSLog(@"开辟线程 %@",self.rootBlock);
        [self.thread start];
    }
    
}

- (void)endRun {
    
    
    self.isRun = NO;
    self.threadEnd = YES;
    if (self.DOCurrent.rootBlock) {
        [self.DOCurrent endRun];
    }
    if (self.ELSECurrent.rootBlock) {
        [self.ELSECurrent endRun];
    }
    [self.currentBlock.defaultBlockView setDisHighlight];
    
    NSLog(@"end  %@",[self.rootBlock getBlockValues].firstObject);
    
    //    if (![self.thread isCancelled] && ![self.thread isFinished]) {
    //
    //        [self.thread cancel];
    //    }
    [self.thread cancel];
    
    self.loopCount = 0;
    self.currentBlock = nil;
    
    self.isRun = YES;
    [self.condition signal];
    
    self.threadEnd = NO;
    [self.threadCon signal];
    
    
    
    [[CustomNotificationCenter sharedCenter].center removeObserver:self];
    
    self.thread = nil;
    
    if ([self.rootBlock.name isEqualToString:@"while"]) {
        
        
        self.rootBlock = self.rootBlock;
    }
}

- (void)beginRun {
    
    
    while (self.loopCount) {
        
        if ([[NSThread currentThread] isCancelled]) {
            
            [NSThread exit];
            
            return ;
        }
        
        while (self.currentBlock) {
            
            if ([[NSThread currentThread] isCancelled]) {
                
                [NSThread exit];
                return ;
            }
            
            NSArray * valuesType = @[@"set_value",@"use_change",@"variable_repetition_num",@"variable_repetition",@"variable_if",@"variable_if_else"];
            
            self.isRun = NO;
            //执行过程中赋值保持current的最新
            BKYBlock * current = self.currentBlock;
            
            if ([valuesType containsObject:current.name]) {
                
                [[BlocklyControl shardControl] showVlaueView:YES];
            }
            
            NSArray * typeNames = @[@"function",@"always_repeat",@"repetition_num"];
            NSArray * ifTypeNames = @[@"if",@"if2",@"if_else",@"if_else2",@"variable_if",@"variable_if_else"];
            NSArray * rapetType = @[@"repetition_until1",@"repetition_until2",@"variable_repetition_num",@"variable_repetition"];
            if ([typeNames containsObject:current.name]) {
                
                [self.DOCurrent runCurrent];
                
            } else if ([rapetType containsObject:current.name]) {
                
                [self runLoopbBlock];
                
            } else if ([ifTypeNames containsObject:current.name]) {
                
                [self runIfElseBlock];
                
            } else {
                
                [self runDefoulBlock];
            }
            
            
            [self.condition lock];
            while (!self.isRun) {
                
                [self.condition wait];
            }
            [self.condition unlock];
            
            
        }
        
        
        [self overRun];
        
        
        [self.threadCon lock];
        while (self.threadEnd) {
            
            [self.threadCon wait];
        }
        [self.threadCon unlock];
    }
    
    [self overRun];
    
    [self.thread cancel];
    [NSThread exit];
    self.thread = nil;
}

- (void)runDefoulBlock {
    
    
    BKYBlock * current = self.currentBlock;
    
    [current.defaultBlockView setHighlight];
    NSDictionary * types = [APPControll getTypeDic];
    
    NSString * sendKey = types[current.name];
    
    if (sendKey.length > 0) {
        
        [[CustomNotificationCenter sharedCenter] addObserver:self block:current callback: @selector(bluetoothCallbcak:)];
        
        [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:current];
        
    } else {
        
        //无特殊操作block
        if ([current.name isEqualToString:@"do_function"]) {
            
            self.funcCurrent = [BlocklyControl shardControl].functions[[current getBlockValues].firstObject];
            self.funcCurrent.loopCount = 1;
            self.funcCurrent.superBlock = self;
            [self.funcCurrent runCurrent];
            
            return ;
        }
        if ([current.name isEqualToString:@"long_time"]) {
            
            NSArray * values = [current getBlockValues];
            NSInteger mi = [values.firstObject integerValue];
            CGFloat sc = [values.lastObject floatValue];
            NSTimeInterval sleepTime = mi * 60 + sc;
            
            [NSThread sleepForTimeInterval:sleepTime];
            
        }
        
        if ([current.name isEqualToString:@"random_time"]) {
            
            NSArray * value = [current getBlockValues];
            NSInteger random = [value.lastObject integerValue];
            NSInteger newTime = 0;
            if (random != 0) {
                
                newTime = arc4random()%random +1;
            }
            
            NSLog(@"等待 %d",newTime );
            [NSThread sleepForTimeInterval:newTime];
        }
        
        if ([current.name isEqualToString:@"set_value"]) {
            
            [[BlocklyControl shardControl] showVlaueView:YES];
            
            NSArray * values = [current getBlockValues];
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            
            NSString * svalue = values.lastObject;
            
            if ([key containsString:@"bl"]) {
                
                NSString * svalue = values.lastObject;
                
                ValueModel * newModel = [BlocklyControl shardControl].values[svalue];
                
                model.value = newModel.value;
            }
            if ([self includeChinese:svalue]) {
                ///读取传感器值
                
                NSArray * array = @[@"超声波传感器距离",@"体感倾斜角度",@"声音传感器分贝",@"光敏传感器亮度",@"压力传感器压力",@"电位机数值",@"滑动变阻器数值"];
                NSInteger index = [array containsObject:values.lastObject];
                
                switch (index) {
                    case 0:
                        
                        break;
                    case 1:
                        
                        break;
                    case 2:
                        
                        break;
                    case 3:
                        
                        break;
                    case 4:
                        
                        break;
                    case 5:
                        
                        break;
                    default:
                        break;
                }
                
            } else {
                
                model.value = [values.lastObject floatValue];
                [NSThread sleepForTimeInterval:self.delay];
            }
        }
        
        if ([current.name isEqualToString:@"use_change"]) {
            
            [[BlocklyControl shardControl] showVlaueView:YES];
            
            NSArray * values = [current getBlockValues];
            NSString * key = values.lastObject;
            NSArray * runs = @[@"+",@"-",@"x",@"÷"];
            
            NSString * run = values[0];
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            
            NSInteger index = [runs indexOfObject:run];
            
            switch (index) {
                case 0:
                    model.value += [values[1] floatValue];
                    break;
                    
                case 1:
                    model.value -= [values[1] floatValue];
                    break;
                case 2:
                    model.value *= [values[1] floatValue];
                    break;
                case 3:
                    if ([values[1] floatValue] != 0) {
                        model.value /= [values[1] floatValue];
                    } else {
                        [CustomHUD showText:@"除数不能为0"];
                        [[BlocklyControl shardControl] stopAllBlockTree];
                    }
                    break;
                default:
                    break;
            }
            if (model.value >= 10000000) {
                model.value = 1000000;
            }
            
            [NSThread sleepForTimeInterval:self.delay];
        }
        
        [self.currentBlock.defaultBlockView setDisHighlight];
        self.currentBlock = self.currentBlock.nextBlock;
        self.isRun = YES;
        
    }
    
    
}

- (BOOL)includeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (void)runIfElseBlock {
    
    self.firstTrue = 1;
    self.sectionTrue = 1;
    ///if else 判断
    BKYBlock * current = self.currentBlock;
    NSArray * ifTypeNames = @[@"if",@"if2",@"if_else",@"if_else2",@"variable_if",@"variable_if_else"];
    NSInteger index = [ifTypeNames indexOfObject:current.name];
    NSArray * values = [current getBlockValues];
    switch (index) {
        case 0: {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self block:current callback: @selector(ifNotifitionCallback:)];
            
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:current];
            self.isRun = NO;
            
            [NSThread sleepForTimeInterval:self.ifDelay];
            
            if (self.superBlock.firstTrue == 1<<0) {
                
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                
            } else if (self.superBlock.firstTrue == 1<<1) {
                
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
                
            } else if (self.superBlock.firstTrue == 1<<2) {
                [self.DOCurrent runCurrent];
                
            }
            
            break;
        }
        case 1: {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self block:current callback: @selector(ifNotifitionCallback:)];
            
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:current];
            
            self.isRun = NO;
            
            self.isAnd = [values[1] isEqualToString:@"and"];
            
            [NSThread sleepForTimeInterval:self.ifDelay];
            
            NSInteger sum = self.superBlock.firstTrue + self.superBlock.sectionTrue;
            
            if (sum == 1<<0) {
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
                
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                
                break ;
            } else if (self.isAnd && (sum == 8)) {
                [self.DOCurrent runCurrent];
                
            } else if (self.isAnd && sum < 8) {
                
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
                
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                
            } else if (!self.isAnd && sum > 4) {
                
                [self.DOCurrent runCurrent];
            } else if (!self.isAnd && sum <=4) {
                
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
                
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                
            }
            
            break;
        }
        case 2: {
            [[CustomNotificationCenter sharedCenter] addObserver:self block:current callback: @selector(ifNotifitionCallback:)];
            
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:current];
            self.isRun = NO;
            
            [NSThread sleepForTimeInterval:self.ifDelay];
            
            if (self.superBlock.firstTrue == 1<<0) {
                
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                
                [self.ELSECurrent runCurrent];
                
                
            } else if (self.superBlock.firstTrue == 1<<1) {
                
                [self.ELSECurrent runCurrent];
            } else if (self.superBlock.firstTrue == 1<<2) {
                [self.DOCurrent runCurrent];
                
            }
            
            
            break;
        }
        case 3: {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self block:current callback: @selector(ifNotifitionCallback:)];
            
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:current];
            
            self.isRun = NO;
            
            self.isAnd = [values[1] isEqualToString:@"and"];
            
            [NSThread sleepForTimeInterval:self.ifDelay];
            
            NSInteger sum = self.superBlock.firstTrue + self.superBlock.sectionTrue;
            
            if (sum == 1<<0) {
                [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:current.name values:values];
                [self.ELSECurrent runCurrent];
                
                break ;
            } else if (self.isAnd && (sum == 8)) {
                [self.DOCurrent runCurrent];
                
            } else if (self.isAnd && sum < 8) {
                
                [self.ELSECurrent runCurrent];
            } else if (!self.isAnd && sum > 4) {
                
                [self.DOCurrent runCurrent];
            } else if (!self.isAnd && sum <=4) {
                
                [self.ELSECurrent runCurrent];
            }
            
            
            break;
        }
        case 4: {
            //判断全局变量进行控制
            NSString * str = values[1];
            NSArray * array = @[@">",@"<",@"=",@"≠"];
            
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            NSString * valueStr = values.lastObject;
            BOOL isTrue = NO;
            
            if ([valueStr containsString:@"bl"]) {
                
                NSString * name = [valueStr componentsSeparatedByString:@"|"].lastObject;
                ValueModel * smodel = [BlocklyControl shardControl].values[name];
                
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > smodel.value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < smodel.value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == smodel.value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != smodel.value;
                        
                        break;
                    }
                    default:
                        break;
                }
                
                
            } else {
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != value;
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            [NSThread sleepForTimeInterval:self.ifDelay];
            if (isTrue) {
                
                [self.DOCurrent runCurrent];
                
            } else {
                
                self.currentBlock = self.currentBlock.nextBlock;
                self.isRun = YES;
                [self.condition signal];
            }
            
            
            break;
        }
        case 5: {
            //判断全局变量进行控制
            NSString * str = values[1];
            NSArray * array = @[@">",@"<",@"=",@"≠"];
            
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            NSString * valueStr = values.lastObject;
            BOOL isTrue = NO;
            
            if ([valueStr containsString:@"bl"]) {
                
                NSString * name = [valueStr componentsSeparatedByString:@"|"].lastObject;
                ValueModel * smodel = [BlocklyControl shardControl].values[name];
                
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > smodel.value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < smodel.value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == smodel.value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != smodel.value;
                        
                        break;
                    }
                    default:
                        break;
                }
                
                
            } else {
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != value;
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            [NSThread sleepForTimeInterval:self.ifDelay];
            if (isTrue) {
                
                [self.DOCurrent runCurrent];
                
            } else {
                [self.ELSECurrent runCurrent];
            }
            
            break;
        }
        default:
            break;
    }
    
}


- (void)runLoopbBlock {
    
    NSArray * rapetType = @[@"repetition_until1",@"repetition_until2",@"variable_repetition_num",@"variable_repetition"];
    BKYBlock * block = self.currentBlock;
    NSArray * values = [block getBlockValues];
    NSInteger index = [rapetType indexOfObject:block.name];
    switch (index) {
        case 0: {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self block:block callback: @selector(ifNotifitionCallback:)];
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:block];
            self.isRun = NO;
            [self.DOCurrent runCurrent];
            
            break;
        }
        case 1: {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self block:block callback:@selector(ifNotifitionCallback:)];
            [[BLEControl sharedControl] sendBluetoothWithCurrentBlock:block];
            self.isRun = NO;
            [self.DOCurrent runCurrent];
            
            break;
        }
        case 2: {
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            
            self.isRun = NO;
            self.DOCurrent.loopCount = model.value;
            [self.DOCurrent runCurrent];
            
            break;
        }
        case 3: {
            
            self.firstTrue = 1;
            self.sectionTrue = 1;
            ///根据全局变量判断 交给first和secondtrue辅助处理
            
            NSString * str = values[1];
            NSArray * array = @[@">",@"<",@"=",@"≠"];
            
            NSString * key = values.firstObject;
            
            ValueModel * model = [BlocklyControl shardControl].values[key];
            NSString * valueStr = values.lastObject;
            BOOL isTrue = NO;
            
            if ([valueStr containsString:@"bl"]) {
                
                NSString * name = [valueStr componentsSeparatedByString:@"|"].lastObject;
                ValueModel * smodel = [BlocklyControl shardControl].values[name];
                
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > smodel.value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < smodel.value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == smodel.value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != smodel.value;
                        
                        break;
                    }
                    default:
                        break;
                }
                
                
            } else {
                NSInteger index= [array indexOfObject:str];
                CGFloat value = [values.lastObject floatValue];
                switch (index) {
                    case 0: {
                        isTrue = model.value > value;
                        break;
                    }
                    case 1: {
                        isTrue = model.value < value;
                        break;
                    }
                    case 2: {
                        isTrue = model.value == value;
                        
                        break;
                    }
                    case 3: {
                        isTrue = model.value != value;
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            if (isTrue) {
                
                self.isRun = NO;
                [self.DOCurrent runCurrent];
                
            } else {
                self.DOCurrent.loopCount = 0;
                [self.DOCurrent endRun];
            }
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)ifNotifitionCallback:(NSNotification *)noti {
    
    NSDictionary * dict = noti.userInfo;
    
    NSValue * value = dict[@"callback"];
    
    NSString * spoint = [noti.name componentsSeparatedByString:@"Point"].lastObject;
    
    unsigned long point = strtoul([spoint UTF8String], 0, 16);
    
    NSInteger success = 0;
    
    if (point == 0x14 || point == 0x15 || point == 0x16) {
        
        ButtonCallback callBack;
        [value getValue:&callBack];
        
        success = callBack.value1 == 1?2:1;
        
    } else if (point == 1) {
        
        ButtonCallback callBack;
        [value getValue:&callBack];
        
        if (callBack.lenth2 != 8) {
            
            return ;
        }
        
        NSString * blockValue = [self.rootBlock getBlockValues].lastObject;
        
        if ([blockValue containsString:@"%"]) {
            
            
            if (![self.rootBlock.name isEqualToString:@"while"]) {
                [[BLEControl sharedControl] sendCMDToBluetooth:INFRARED_OF];
                
            }
            NSInteger rValue = [[blockValue componentsSeparatedByString:@"%"].lastObject integerValue];
            rValue = rValue / 100.0 * 256;
            
            if (callBack.value1 > rValue) {
                
                success = 2;
            } else {
                success = 1;
            }
        } else {
            
            if (callBack.value1 > self.infrared) {
                
                if (![self.rootBlock.name isEqualToString:@"while"]) {
                    [[BLEControl sharedControl] sendCMDToBluetooth:INFRARED_OF];
                    
                }
                success = 2;
                
            } else {
                success = 1;
            }
            
        }
        
        
        
    } else if (point == 2) {
        
        ButtonCallback callBack;
        [value getValue:&callBack];
        
        if (callBack.lenth2 != 8) {
            
            return ;
        }
        
        if (callBack.value1 > self.sound) {
            
            if (![self.rootBlock.name isEqualToString:@"while"]) {
                [[BLEControl sharedControl] sendCMDToBluetooth:SOUND_OF];
                
            }
            success = 2;
        } else {
            success = 1;
        }
    } else if (point == 3) {
        
        SixLenthCallback callback;
        [value getValue:&callback];
        
        if (callback.success == 01) {
            
            success = 2;
        } else if (callback.success == 0xff) {
            success = 1;
        }
        
    } else if (point == 4 || point == 5 || point == 9 || point == 10) {
        SixLenthCallback callback;
        [value getValue:&callback];
        
        if (callback.success == 01) {
            
            success = 2;
        } else if (callback.success == 0xff) {
            success = 1;
        }
    } else if (point == 6) {
        
        SixLenthCallback callback;
        [value getValue:&callback];
        
        if (callback.success == 01) {
            
            success = 2;
        } else if (callback.success == 0xff) {
            success = 1;
        }
    } else if (point == 7) {
        
        ButtonCallback callBack;
        [value getValue:&callBack];
        
        if (callBack.value1 == 1) {
            
            success = 2;
        } else {
            success = 1;
        }
        
    } else if (point == 8) {
        
        ButtonCallback callBack;
        [value getValue:&callBack];
        if (callBack.lenth2 != 8) {
            
            return ;
        }
        
        if (callBack.typy2 == 4) {
            
            NSInteger value = callBack.value1 * 16 + callBack.value2;
            
            if (![self.rootBlock.name isEqualToString:@"while"]) {
                [[BLEControl sharedControl] sendCMDToBluetooth:WAVES_OF];
                
            }
            if (value > self.waves) {
                
                success = 2;
            }
            //            [[BLEControl sharedControl] sendCMDToBluetooth:WAVES_OF];
            
#warning 判断距离是多少触发
            
        } else {
            NSInteger color = callBack.value1;
            NSString * colorStr = [self.currentBlock getBlockValues].firstObject;
            colorStr = [colorStr componentsSeparatedByString:@"|"].lastObject;
            NSInteger forcolor = [colorStr integerValue];
            if (![self.rootBlock.name isEqualToString:@"while"]) {
                [[BLEControl sharedControl] sendCMDToBluetooth:COLOR_OF];
                
            }
            if (color == forcolor) {
                
                success = 2;
            }
            
            
#warning 对比颜色的值
        }
    }
    
    NSInteger news = success;
    if (news == 2) {
        
        if (self.firstTrue == 1) {
            self.firstTrue = 1 << news;
        } else {
            self.sectionTrue = 1 << news;
        }
        
        if (success == 2) {
            [[CustomNotificationCenter sharedCenter].center removeObserver:self name:noti.name object:nil];
        }
        
    }
    
}

- (void)bluetoothCallbcak:(NSNotification *)noti {
    
    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    
    if (noti.object) {
        return ;
    }
    BOOL isSuccess = NO;
    
    [[CustomNotificationCenter sharedCenter].center removeObserver:self name:noti.name object:nil];
    
    NSString * point = [noti.name componentsSeparatedByString:@"Point"].lastObject;
    
    if ([@[@"machine_speed_direction",@"machine_stop",@"fan_stop",@"fan_speed"] containsObject:self.currentName]) {
        
        const void * bytes = data.bytes;
        
        SixLenthCallback * callback = (SixLenthCallback *)bytes;
        if (callback->success == 01) {
            
            isSuccess = YES;
            
        } else {
            
            isSuccess = NO;
        }
    } else if ([self.currentName isEqualToString:@"machine_two_stop"]) {
        
        const void * bytes = data.bytes;
        
        SixLenthCallback * callback = (SixLenthCallback *)bytes;
        BOOL success = callback->success == 01;
        
        [self.stopTwo addObject:@(success)];
        
        if (self.stopTwo.count > 2) {
            
            BOOL first = [self.stopTwo[0] boolValue];
            
            isSuccess = first && success;
        }
        
    } else {
        
        const void * bytes = data.bytes;
        
        SixLenthCallback * callback = (SixLenthCallback *)bytes;
        
        if (callback->success == 01) {
            
            isSuccess = YES;
            
        } else {
            
            isSuccess = NO;
        }
        
        
    }
    
    
    NSArray * tyNames = @[@"light_color",@"highlight_level",@"light1"];
    
    NSInteger index = [tyNames indexOfObject:self.currentName];
    RGBLightModel * model = [BlocklyControl shardControl].light;
    switch (index) {
        case 0: {
            
            model.RGBColor = [self.currentBlock getBlockValues].lastObject;
            
            break;
        }
        case 1: {
            model.highlightLevel = [[self.currentBlock getBlockValues].lastObject integerValue];
            break;
        }
        case 2: {
            
            model.light1Level = [[self.currentBlock getBlockValues].lastObject integerValue];
            
            break;
        }
        default:
            break;
    }
    
    if ([self.currentName isEqualToString:@"buzzer_on_off"]) {
        
        CGFloat time = [BlocklyControl shardControl].buzzerTime;
        time = time==0?1:time;
        [NSThread sleepForTimeInterval:time];
        NSString * key = [NSString stringWithFormat:PLAY_BUZZER,[point integerValue],0];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
        
    }
    
    if ([self.currentName isEqualToString:@"buzzer_level"]) {
        [BlocklyControl shardControl].buzzerLevel = [self.currentBlock getBlockValues].firstObject;
        NSInteger time = [[self.currentBlock getBlockValues][1] floatValue];
        [BlocklyControl shardControl].buzzerTime = time;
        
        [NSThread sleepForTimeInterval:time];
        NSString * key = [NSString stringWithFormat:PLAY_BUZZER,[point integerValue],0];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
    }
    //            [BlocklyControl shardControl].light.RGBColor
    
    const void * bytes = data.bytes;
    
    SixLenthCallback * callback = (SixLenthCallback *)bytes;
    
    if (callback->success == 01) {
        
        isSuccess = YES;
        
    } else {
        
        isSuccess = NO;
    }
    
    if (isSuccess) {
        
        
        if ([@[@"daily_words",@"action",@"animal_sound",@"transport_sound"] containsObject:self.currentName]) {
            
            CGFloat time = [[self.currentBlock getBlockValues][1] floatValue];
            [NSThread sleepForTimeInterval:time];
        } else {
            [NSThread sleepForTimeInterval:self.delay];
            
        }
        
        [self.currentBlock.defaultBlockView setDisHighlight];
        self.currentBlock = self.currentBlock.nextBlock;
        
        self.isRun = YES;
        [self.condition signal];
        
    } else {
        
        [[BlocklyControl shardControl] stopAllBlockTree];
    }
    
}

- (void)didFinishCurrentBlock:(CurrentBlock *)currentBlock {
    
    //分支树结束后走的回调 包括主树 和其他分支
    
    if (currentBlock == self) {
        //主树 已走完
        
        [self endRun];
        
        return ;
    }
    
    if ([currentBlock.rootBlock.name isEqualToString:@"function"]) {
        
        currentBlock.loopCount = 0;
        [self.currentBlock.defaultBlockView setDisHighlight];
        self.currentBlock = self.currentBlock.nextBlock;
        self.isRun = YES;
        [self.condition signal];
        
        return ;
    }
    
    
    NSArray * blocks = @[self.DOCurrent, self.ELSECurrent];
    if ([blocks containsObject:currentBlock]) {
        //当分枝树走完
        NSArray * typeNames = @[@"if",@"if2",@"if_else",@"if_else2",@"variable_if",@"variable_if_else",@"always_repeat",@"repetition_num",@"repetition_until1",@"repetition_until2",@"variable_repetition_num",@"variable_repetition"];
        
        
        
        if ([typeNames containsObject: self.currentName]) {
            
            
            self.currentBlock = self.currentBlock.nextBlock;
            self.isRun = YES;
            [self.condition signal];
        }
        
    }
}

- (void)overRun {
    
    NSArray * typeNames = @[@"if",@"if2",@"if_else",@"if_else2",@"variable_if",@"variable_if_else",@"always_repeat",@"repetition_num",@"repetition_until1",@"repetition_until2",@"variable_repetition_num",@"variable_repetition",@"function"];
    if ([typeNames containsObject:self.rootBlock.name]) {
        
        NSInteger index = [typeNames indexOfObject:self.rootBlock.name];
        NSArray * values = [self.rootBlock getBlockValues];
        if (values.count > 2) {
            self.isAnd = [values[1] isEqualToString:@"and"];
        }
        switch (index) {
            case 8: {
                
                if (self.superBlock.firstTrue == 1<<2) {
                    
                    self.loopCount = 0;
                    
                }
                break;
            }
            case 9: {
                
                NSInteger sum = self.superBlock.firstTrue + self.superBlock.sectionTrue;
                if (self.isAnd && sum == 8) {
                    
                    self.loopCount = 0;
                } else if (!self.isAnd && sum > 4) {
                    
                    self.loopCount = 0;
                }
                
                break;
            }
            case 10: {
                //根据全局变量控制
                
                break;
            }
            case 11: {
                //根据全局变量控制
                
                NSString * str = values[1];
                NSArray * array = @[@">",@"<",@"=",@"≠"];
                
                NSString * key = values.firstObject;
                
                ValueModel * model = [BlocklyControl shardControl].values[key];
                CGFloat value = 0;
                
                value = [values.lastObject floatValue];
                
                NSInteger index= [array indexOfObject:str];
                BOOL isend = NO;
                switch (index) {
                    case 0: {
                        isend = model.value > value;
                        
                        break;
                    }
                    case 1: {
                        isend = model.value < value;
                        break;
                    }
                    case 2: {
                        isend = model.value == value;
                        
                        break;
                    }
                    case 3: {
                        isend = model.value != value;
                        
                        break;
                    }
                    default:
                        break;
                }
                if (isend) {
                    
                    self.loopCount = 0;
                    
                }
                
                
                break;
            }
            default:
                break;
        }
        
    }
    
    
    if (self.loopCount >=1) {
        
        if (self.rootBlock.inputs.count >= 2) {
            
            self.currentBlock = self.rootBlock.inputs[1].connectedBlock;
        }
        
        self.loopCount--;
        self.isRun = YES;
        
        
    } else {
        
        [self endRun];
        
        if ([self.rootBlock.name isEqualToString:@"while"]) {
            
            //为while start走完
            [BlocklyControl shardControl].whileIsRun = NO;
            [BlocklyControl shardControl].currentWhile = nil;
            
            //        self.isRun = YES;
        }
        [self.superBlock didFinishCurrentBlock:self];
    }
    
}


@end

