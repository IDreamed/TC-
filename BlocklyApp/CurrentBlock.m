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
#import "GetValueModle.h"

@interface CurrentBlock ()

///执行当前block树的线程
@property (strong, nonatomic) NSThread * thread;
///线程控制辅助
@property (strong, nonatomic) NSCondition * condition;
///线程终止判断辅助
@property (strong, nonatomic) NSCondition * threadCon;
@property (assign, nonatomic) BOOL threadEnd;



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
///选中的颜色
@property (assign, nonatomic) NSInteger color;
///传感器颜色
@property (assign, nonatomic) NSInteger colorTwo;

@property (copy, nonatomic) NSMutableArray * stopTwo;


///while是否成功
@property (assign, nonatomic) BOOL isTrue;
///重复直到 是否触发
@property (assign, nonatomic) BOOL isStopRepeat;
///传感器In1的值
@property (assign, atomic) CGFloat IN1;
///传感器In2的值
@property (assign, atomic) CGFloat IN2;
///传感器In3的值
@property (assign, atomic) CGFloat IN3;


@end

@implementation CurrentBlock

- (void)dealloc {
    
    [[CustomNotificationCenter sharedCenter] removeAllNotifitionWithObserver:self];
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

- (void)setIsTrue:(BOOL)isTrue {
    _isTrue = isTrue;
    
    if (_isTrue && [self.rootBlock.name isEqualToString:@"while"]) {
        
        [self runWhileBlock];
    }
}

- (void)setIsStopRepeat:(BOOL)isStopRepeat {
    _isStopRepeat = isStopRepeat;
    
    if (_isStopRepeat && [self.rootBlock.name isEqualToString:@"repetition_until1"]) {
        
        self.loopCount = 0;
        
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

//- (CurrentBlock *)DOCurrent {
//    
//    if (!_DOCurrent) {
//        _DOCurrent = [[CurrentBlock alloc] init];
//    }
//    return _DOCurrent;
//}
//- (CurrentBlock *)ELSECurrent {
//    
//    if (!_ELSECurrent) {
//        _ELSECurrent = [[CurrentBlock alloc] init];
//    }
//    return _ELSECurrent;
//}

- (void)coffBlock {
    self.IN1 = 0;
    self.IN2 = 0;
    self.IN3 = 0;
    self.currentName = self.currentBlock.name;
    self.DOCurrent = nil;
    self.ELSECurrent = nil;
    self.isTrue = NO;
    if (self.currentBlock.inputs.count > 1) {
        
        for (int i=1; i<self.currentBlock.inputs.count; i++) {
            
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
    
    NSArray * array = @[@"always_repeat",@"repetition_num",@"repetition_until1",@"repetition_for"];
    
    NSInteger index = [array indexOfObject:self.currentBlock.name];
    
    switch (index) {
        case 0: {
            
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 1: {
            
            NSInteger count = [self getValueWithOutPutBlock:[self.currentBlock allBlockInSelf].firstObject].numberValue;
            self.DOCurrent.loopCount = count;
            
            break;
        }
        case 2: {
            
            
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 3: {
            self.DOCurrent.loopCount = 10000;
            
            NSString * str = [self.currentBlock getBlockValues].firstObject;
            NSArray * inputArray = self.currentBlock.allBlockInSelf;
            CGFloat rangeDown = [self getValueWithOutPutBlock:inputArray[1]].numberValue;
            CGFloat rangeUp = [self getValueWithOutPutBlock:inputArray[2]].numberValue;
            
            BOOL up = rangeUp > rangeDown;
            BOOL down = rangeDown > rangeUp;
            
            if ([@[@"+",@"x"] containsObject:str]) {
                
                if (!up && down) {
                    
                    self.DOCurrent.loopCount = 0;
                }
                
            } else if ([@[@"-",@"÷"] containsObject:str]) {
                if (up && !down) {
                    
                    self.DOCurrent.loopCount = 0;
                }
            }
            break;
        }
       
    }
    
    
}

- (void)coffNotifition {
    
    ///查看block具体数据注册相对的通知
    NSArray * blocks = [self.rootBlock allBlockInSelf];
    if (blocks.count) {
        
        NSString * key = DEFAULT;
        BKYBlock * block = blocks.firstObject;
        [self getValueWithOutPutBlock:block];
    }
}
///遍历output的Block 得到最终的值
- (GetValueModle *)getValueWithOutPutBlock:(BKYBlock *)block {
    
    GetValueModle * model = [[GetValueModle alloc] init];
    
    if ([block.name containsString:@"action"]) {
        
        NSString * point = [block getBlockValues].firstObject;
        GetValueModle * valueModel = [self getValueWithOutPutBlock:[block allBlockInSelf].firstObject];
        NSString * key = DEFAULT;
        if ([block.name containsString:@"sound"]) {
            
            key = SOUND;
            
        }
        NSInteger port = [point componentsSeparatedByString:@"IN"].lastObject.floatValue;
        key = [NSString stringWithFormat:key,port];
        
        BKYBlock * inputBlock = block.outputConnection.targetBlock;
        if ([inputBlock.name isEqualToString:@"while"]) {
            self.sound = valueModel.numberValue;
            [[CustomNotificationCenter sharedCenter] addObserver:self name:point callback:@selector(getWhileOutputCallback:) object:nil];
            [[BLEControl sharedControl] sendCMDToBluetooth: key];
            NSLog(@"%@",point);
            model = nil;
        } else {
            
            [[CustomNotificationCenter sharedCenter] addObserver:self name:point callback:@selector(getOutputCallback:) object:nil];
            [[BLEControl sharedControl] sendCMDToBluetooth:key];
            [NSThread sleepForTimeInterval:1];
    
            model.boolValue = [[self valueForKey:[block getBlockValues].firstObject] doubleValue] > valueModel.numberValue;
        }
        
       
        
        return model;
    }
    
    NSArray * typeNames = @[@"number_value",@"bool_value",@"colour_value",@"string_value"];
    NSInteger index = [typeNames indexOfObject:block.name];
    switch (index) {
        case 0:{
            
            model.numberValue = [[block getBlockValues].firstObject doubleValue];
            
            break;
            
        }
        case 1:{
            
            model.boolValue = [[block getBlockValues].firstObject isEqualToString:@"true"];
            
            break;
            
        }
            
        case 2:{
            
            break;
            
        }
        case 3:{
            model.colourValue = [block getBlockValues].firstObject;
            
            
            break;
        }
            
    }
    
    if ([block.name isEqualToString:@"animate_light"]) {
        
        /// 暂时不写
    }
    
    if ([block.name isEqualToString:@"port_in"]) {
        
        NSString * port = [block getBlockValues].firstObject;
        NSString * key = [NSString stringWithFormat:SOUND,[[port componentsSeparatedByString:@"IN"].lastObject integerValue]];
        
        [[CustomNotificationCenter sharedCenter] addObserver:self name:port callback:@selector(getOutputCallback:) object:nil];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
        
        [NSThread sleepForTimeInterval:1];
        
        model.numberValue = [[self valueForKey:[block getBlockValues].firstObject] doubleValue];
    }
    
    if ([block.name isEqualToString:@"port_get_type"]) {
        
#warning 先不写
    }
    if ([block.name isEqualToString:@"get_timer"]) {
        
        NSString * unit = [block getBlockValues].firstObject;
        NSDate * beginTime = [BlocklyControl shardControl].beginTime;
        NSDate * endTime = [BlocklyControl shardControl].endTime;
        NSTimeInterval interval = 0;
        
        if (beginTime && endTime) {
            
            interval = [endTime timeIntervalSinceDate:beginTime];
            
        } else if (beginTime) {
            
            interval = [beginTime timeIntervalSinceNow];
        }
        model.numberValue = (int)interval;
        if ([unit isEqualToString:@"ms"]) {
            
            model.numberValue = (int)(interval * 1000);
        }
        
    }
    if ([block.name isEqualToString:@"not_value"]) {
        
        GetValueModle * smodel = [self getValueWithOutPutBlock:block.allBlockInSelf.firstObject];
        model.boolValue = !smodel.boolValue;
    }
    
    if ([block.name isEqualToString:@"control_compare"]) {
        
        CGFloat number1 = [self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].numberValue;
        CGFloat number2 = [self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].numberValue;
        NSString * str = [block getBlockValues].firstObject;
        NSArray * strs = @[@"=",@"≠",@">",@"≥",@"<",@"≤"];
        NSInteger sindex = [strs indexOfObject:str];
        switch (sindex) {
                
            case 0: {
                
                model.boolValue = (number1 == number2)?YES:NO;
                
                break;
            }
            case 1: {
                model.boolValue = (number1 != number2)?YES:NO;
                
                break;
            }
            case 2: {
                model.boolValue = (number1 > number2)?YES:NO;
                
                break;
            }
            case 3: {
                model.boolValue = (number1 >= number2)?YES:NO;
                
                break;
            }
            case 4: {
                model.boolValue = (number1 < number2)?YES:NO;
                
                break;
            }
            case 5: {
                
                model.boolValue = (number1 <= number2)?YES:NO;
                
                
                break;
            }
        }
    }
    
    if ([block.name isEqualToString:@"and_or"]) {
        
        BOOL bool1 = [self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].boolValue;
        bool bool2= [self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].boolValue;
        
        NSString * str = [block getBlockValues].firstObject;
        if ([str isEqualToString:@"and"]) {
            
            model.boolValue = (bool1 && bool2)?YES:NO;
            
        } else {
            
            model.boolValue = (bool1 || bool2)?YES:NO;
        }
    }
    
    if ([block.name isEqualToString:@"math_calculator"]) {
        
        CGFloat number1 = [self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].numberValue;
        CGFloat number2 = [self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].numberValue;
        NSString * str = [block getBlockValues].firstObject;
        NSArray * strs = @[@"+",@"-",@"x",@"÷"];
        NSInteger index = [strs indexOfObject:str];
        switch (index) {
            case 0: {
                model.numberValue = number1 + number2;
                break;
            }
            case 1: {
                
                model.numberValue = number1 - number2;
                
                break;
            }
            case 2: {
                
                model.numberValue = number1 * number2;
                
                break;
            }
            case 3: {
                
                model.numberValue = number2 == 0?0:number1/number2;
                break;
            }
        }
    }
    
    if ([block.name isEqualToString:@"math_odevity"]) {
        
        CGFloat number = [self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].numberValue;
        NSInteger intVale = number;
        
        NSInteger i = intVale % 2;
        NSString * str = [block getBlockValues].firstObject;
        if ([str isEqualToString:@"奇数"]) {
            
            model.boolValue = i==1;
        } else {
            model.boolValue = i==0;
            
        }
    }
    
    if ([block.name isEqualToString:@"math_intger"]) {
        
        CGFloat number = [self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].numberValue;
        NSInteger interValue = round(number);
        
        model.numberValue = interValue;
    }
    if ([block.name isEqualToString:@"math_cover_to"]) {
        
        CGFloat number = [self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].numberValue;
        
        CGFloat rangeDown = [self getValueWithOutPutBlock:[block allBlockInSelf][1]].numberValue;
        CGFloat rangeUp = [self getValueWithOutPutBlock:[block allBlockInSelf][2]].numberValue;
        
        CGFloat rangeDown1 = [self getValueWithOutPutBlock:[block allBlockInSelf][3]].numberValue;
        CGFloat rangeUp1 = [self getValueWithOutPutBlock:[block allBlockInSelf][4]].numberValue;
        ///y = A*x +B
        CGFloat lenth1 = rangeUp1 - rangeDown1;
        CGFloat lenth = rangeUp - rangeDown;
        CGFloat A = lenth1 / lenth;
        CGFloat B = (rangeDown1 + lenth1/2) - (rangeDown + lenth/2) * A;
        
        CGFloat newNumber = number * A + B;
        model.numberValue = newNumber;
    }
    
    if ([block.name isEqualToString:@"math_cover_proportion"]) {
        
        NSString * port = [block getBlockValues].firstObject;
        NSString * key = [NSString stringWithFormat:SOUND,[[port componentsSeparatedByString:@"IN"].lastObject integerValue]];
        
        [[CustomNotificationCenter sharedCenter] addObserver:self name:port callback:@selector(getOutputCallback:) object:nil];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
        
        [NSThread sleepForTimeInterval:1];
        
        CGFloat number = [[self valueForKey:[block getBlockValues].firstObject] doubleValue];

        
        CGFloat rangeDown = [self getValueWithOutPutBlock:[block allBlockInSelf][1]].numberValue;
        CGFloat rangeUp = [self getValueWithOutPutBlock:[block allBlockInSelf][2]].numberValue;
        CGFloat lenth = rangeUp - rangeDown;
        CGFloat proport = (number - rangeDown)/lenth;
        model.numberValue = proport;
    }
    
    if ([block.name isEqualToString:@"get_value"]) {
    
        
    }
    
    return model;
}

///为了去除清楚IN的输入的辅助变量
static BOOL isFirst = YES;
- (void)getOutputCallback:(NSNotification *)noti {
    
    
    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    const char * bytes = data.bytes;
    ButtonCallback  callback = *(ButtonCallback *)bytes;
    NSInteger point = callback.point;
    NSString * pointStr = NAME_HEAD(point);
    if (![noti.name isEqualToString:pointStr]) {
        
        return ;
    }
    
    NSInteger cvalue = callback.value1;
    
    NSNumber * num = [self valueForKey:noti.name];
    
    if (cvalue > num.floatValue) {
        
        [self setValue:@(cvalue) forKey:noti.name];
    }
    
    if (isFirst) {
        isFirst = NO;
        [self performSelector:@selector(clearNotifitionWithName:) withObject:noti.name afterDelay:1];
        [[BLEControl sharedControl] sendCMDToBluetooth:[NSString stringWithFormat:DEFAULT_OF,point]];
    }
    
    
}

- (void)clearNotifitionWithName:(NSString *)name {
    
    [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:name values:nil];
    isFirst = YES;
}

- (void)getWhileOutputCallback:(NSNotification *)noti {
    
    //    [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:noti.name];
    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    const char * bytes = data.bytes;
    ButtonCallback  callback = *(ButtonCallback *)bytes;
    NSInteger point = callback.point;
    NSInteger cvalue = callback.value1;
    
    if (point != [self stringToPort:noti.name]) {
        
        return ;
    }
    
    if (cvalue > self.sound) {
        
        self.isTrue = YES;
    }
    
    
}

- (NSInteger)stringToPort:(NSString *)port {
    
    NSInteger point;
    
    if ([port containsString:@"OUT"]) {
        
        point = [[port componentsSeparatedByString:@"OUT"].lastObject integerValue];

        point += 3;
    } else {
    
        point = [[port componentsSeparatedByString:@"IN"].lastObject integerValue];
    }
    
    return point;
}

- (void)whileBegin:(NSNotification *)noti {
    
    
    //    [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:noti.name];
    NSDictionary * dict = noti.userInfo;
    NSData * data = dict[@"callback"];
    const char * bytes = data.bytes;
    ButtonCallback  callback = *(ButtonCallback *)bytes;
    NSInteger point = callback.point;
    NSInteger cvalue = callback.value1;
    
    if (point != [self stringToPort:noti.name]) {
        
        return ;
    }
    
    if (cvalue > self.sound) {
        
        self.isTrue = YES;
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
            
//            NSArray * valuesType = @[@"set_value",@"use_change",@"variable_repetition_num",@"variable_repetition",@"variable_if",@"variable_if_else"];
//            
            self.isRun = NO;
            //执行过程中赋值保持current的最新
            BKYBlock * current = self.currentBlock;
//
//            if ([valuesType containsObject:current.name]) {
//                
//                [[BlocklyControl shardControl] showVlaueView:YES];
//            }
            
            NSArray * typeNames = @[@"function",@"always_repeat",@"repetition_num"];
            NSArray * ifTypeNames = @[@"if",@"if_else",@"variable_if",@"variable_if_else"];
            NSArray * rapetType = @[@"repetition_until1",@"repetition_for"];
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
    NSArray * values = [current getBlockValues];
    NSString * notifitionName = values.count?values[0]:@"";
    NSArray * newValues;
    
#pragma mark 电机
    if ([current.name isEqualToString:@"machine_speed_direction"]) {
        
        
        NSInteger time = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
        newValues = @[values[0],values[1],values[2],@(time),values[3]];

    }
    if ([current.name isEqualToString:@"machine_stop"]) {
        
        newValues = @[values[0]];
    }
    
    if([current.name isEqualToString:@"machine_two_stop"]) {
     
        newValues = values;

        [[CustomNotificationCenter sharedCenter] addObserver:self name:values[0] callback:@selector(bluetoothCallbcak:) object:nil];
        notifitionName = values[1];
        
        }
    
    if ([@[@"fan_stop",@"fan_speed"] containsObject:current.name]) {
        
        NSInteger spead = 0;
        
        newValues = values.count > 1? values : @[values[0],@(spead)];
        
    }
    
    if ([current.name isEqualToString:@"machine_swing"]) {
        
        newValues = values;
    }
    
#pragma mark 灯阵
    if ([current.name isEqualToString:@"animation_image"]) {
        
    }
    
#pragma mark 声音
    if ([@[@"daily_words",@"music_sound",@"animal_sound",@"transport_sound"] containsObject:current.name]) {
        
        NSInteger time = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
        newValues = @[values[0],values[1],@(time),values[2]];
    }
    
    if ([current.name isEqualToString:@"buzzer_level"]) {
     
        NSInteger time = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
        newValues = @[values[0],values[1],values[2],@(time),values[3]];
    }
    
#pragma mark 端口
    if ([current.name isEqualToString:@"port_out"]) {
        
        NSString * point = values[0];
        NSInteger value = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
        
        newValues = @[point,@(value)];
        
    }
    
    if ([current.name isEqualToString:@"port_on_off"]) {
        
        newValues = values;
    }
    
#pragma mark 时间
    if ([current.name isEqualToString:@"wait_port_open"]) {
        newValues = values;
    }
    if ([current.name isEqualToString:@"wait_do"]) {
        
    }

    
    if (newValues.count > 0) {
        
        [[CustomNotificationCenter sharedCenter] addObserver:self name:notifitionName callback:@selector(bluetoothCallbcak:) object:nil];
        
        [[BLEControl sharedControl] sendCMDToBluetooth:newValues withBlockName:current.name];
        
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
            NSInteger time = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
            time = [values.firstObject isEqualToString:@"ms"]?time/1000:time;
            
            [NSThread sleepForTimeInterval:time];
            
        }
        
        if ([@[@"reset_timer",@"start_timer"] containsObject:current.name]) {
            
        
            [BlocklyControl shardControl].beginTime = [NSDate date];
            [NSThread sleepForTimeInterval:self.delay];
        }
        
        if ([current.name isEqualToString:@"end_timer"]) {
            
            [BlocklyControl shardControl].endTime = [NSDate date];
            [NSThread sleepForTimeInterval:self.delay];
        }
        
        if ([current.name isEqualToString:@"set_value"]) {
         

            ValueModel * newModel = [BlocklyControl shardControl].values[current.getBlockValues.firstObject];
            CGFloat value = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].numberValue;
            newModel.value = value;
            [NSThread sleepForTimeInterval:self.delay];


        }
        if ([current.name isEqualToString:@"break"]) {
            
            [NSThread sleepForTimeInterval:self.delay];
            [self didBreak];
        }
        
        [self.currentBlock.defaultBlockView setDisHighlight];
        self.currentBlock = self.currentBlock.nextBlock;
        self.isRun = YES;
    }
    
    
}

///break传递
- (void)didBreak {

    if ([self.rootBlock.name containsString:@"repe"]) {
        
        [self endRun];
        return ;
        
    } else {
        
        if (self.superBlock) {
            [self.superBlock didBreak];
        } else {
            return ;
        }
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
    
    NSArray * names = @[@"if",@"if_else"];
    
    BOOL isTrue = [self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject].boolValue;
    
    if (isTrue) {
    
        self.DOCurrent?[self.DOCurrent runCurrent]:self.runNext;
    } else {
    
        self.ELSECurrent?[self.ELSECurrent runCurrent]:self.runNext;

    }
    
}

- (void)runNext {

    self.currentBlock = self.currentBlock.nextBlock;
    self.isRun = YES;
    [self.condition signal];
    
}

- (void)runLoopbBlock {
    
    NSArray * rapetType = @[@"repetition_until1",@"repetition_for"];
    BKYBlock * block = self.currentBlock;
    NSArray * values = [block getBlockValues];
    NSInteger index = [rapetType indexOfObject:block.name];
#warning 未完成
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
                [[BLEControl sharedControl] sendCMDToBluetooth:DEFAULT_OF];
                
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
                    [[BLEControl sharedControl] sendCMDToBluetooth:DEFAULT_OF];
                    
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
                [[BLEControl sharedControl] sendCMDToBluetooth:DEFAULT_OF];
                
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
                [[BLEControl sharedControl] sendCMDToBluetooth:DEFAULT_OF];
                
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
                [[BLEControl sharedControl] sendCMDToBluetooth:DEFAULT_OF];
                
            }
            if (color == forcolor) {
                
                success = 2;
            }
            
            
#warning 对比颜色的值
        }
    }
    
    NSInteger news = success;
    if (news == 2) {
        
        
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

    const void * bytes = data.bytes;
    
    SixLenthCallback * callback = (SixLenthCallback *)bytes;
    
    if (callback->point != [self stringToPort:noti.name]) {
        
        return ;
    }
    
    [[CustomNotificationCenter sharedCenter].center removeObserver:self name:noti.name object:nil];
    
    NSString * point = [noti.name componentsSeparatedByString:@"Point"].lastObject;
    
    if ([@[@"machine_speed_direction",@"machine_stop",@"fan_stop",@"fan_speed"] containsObject:self.currentName]) {
        
        
        if (callback->success == 0x01) {
            
            isSuccess = YES;
            
        } else {
            
            isSuccess = NO;
        }
    } else if ([self.currentName isEqualToString:@"machine_two_stop"]) {
        
       
        BOOL success = callback->success == 01;
        
        [self.stopTwo addObject:@(success)];
        
        if (self.stopTwo.count > 2) {
            
            BOOL first = [self.stopTwo[0] boolValue];
            
            isSuccess = first && success;
        }
        
    } else {
        
        
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
    
    if ([self.currentName isEqualToString:@"buzzer_level"]) {
        [BlocklyControl shardControl].buzzerLevel = [self.currentBlock getBlockValues].firstObject;
        NSInteger time = [[self.currentBlock getBlockValues][1] floatValue];
        [BlocklyControl shardControl].buzzerTime = time;
        
        [NSThread sleepForTimeInterval:time];
        NSString * key = [NSString stringWithFormat:PLAY_BUZZER,[point integerValue],0];
        [[BLEControl sharedControl] sendCMDToBluetooth:key];
    }
    //            [BlocklyControl shardControl].light.RGBColor
    
    
    if (callback->success == 01) {
        
        isSuccess = YES;
        
    } else {
        
        isSuccess = NO;
    }
    
    if (isSuccess) {
        
        
        if ([@[@"daily_words",@"music_sound",@"animal_sound",@"transport_sound"] containsObject:self.currentName]) {

            CGFloat time = [self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject].numberValue;
            if ([self.currentBlock.getBlockValues.lastObject isEqualToString:@"ms"]) {
                
                time = time / 1000;
            }
            
            [NSThread sleepForTimeInterval:time];
        } else {
            [NSThread sleepForTimeInterval:self.delay];
            
        }
        
        [self.currentBlock.defaultBlockView setDisHighlight];
        self.currentBlock = self.currentBlock.nextBlock;
        
        self.isRun = YES;
        [self.condition signal];
        
    } else {
        
        [self endRun];

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
    
    
    if (self.DOCurrent == currentBlock || self.ELSECurrent == currentBlock) {
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
        
        switch (index) {
            case 8: {
                
                if (self.superBlock.isTrue) {
                    
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

