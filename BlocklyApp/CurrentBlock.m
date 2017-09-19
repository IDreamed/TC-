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
#import "UpdateValueModel.h"

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


///选中的颜色
@property (assign, nonatomic) NSInteger color;
///传感器颜色
@property (assign, nonatomic) NSInteger colorTwo;

@property (copy, nonatomic) NSMutableArray * stopTwo;

///重复直到 while触发
@property (nonatomic, assign) BOOL isTrue;
///for 循环的计数
@property (nonatomic, assign) CGFloat forNumber;
///for 循环中 是加计数还是减
@property (nonatomic, assign) BOOL forIsTure;

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
    if ([@[@"while",@"repetition_until1"] containsObject:rootBlock.name] ) {
        
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
    
    if (_isTrue && [self.rootBlock.name isEqualToString:@"repetition_until1"]) {
        
        self.loopCount = 0;
        
        [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:UPDATE_IN_NAME values:nil];
        
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
            
            NSInteger count = [[self getValueWithOutPutBlock:[self.currentBlock allBlockInSelf].firstObject].value integerValue];
            self.DOCurrent.loopCount = count;
            
            break;
        }
        case 2: {
            
            
            self.DOCurrent.loopCount = 10000;
            
            break;
        }
        case 3: {
            self.DOCurrent.loopCount = 10000;
            
            NSArray * inputArray = self.currentBlock.allBlockInSelf;
            CGFloat rangeDown = [[self getValueWithOutPutBlock:inputArray[0]].value floatValue];
            CGFloat rangeUp = [[self getValueWithOutPutBlock:inputArray[1]].value floatValue];
            self.DOCurrent.forIsTure = rangeUp >= rangeDown;
            self.DOCurrent.forNumber = rangeDown;
            
            break;
        }
       
    }
    
    
}

- (void)coffNotifition {
    
    [[CustomNotificationCenter sharedCenter] addObserver:self name:UPDATE_IN_NAME callback:@selector(getWhileOutputCallback) object:nil];
   
}
///遍历output的Block 得到最终的值
- (GetValueModle *)getValueWithOutPutBlock:(BKYBlock *)block {
    
    GetValueModle * model = [[GetValueModle alloc] init];
    
    if ([block.name containsString:@"action"]) {
        
        NSString * point = [block getBlockValues].firstObject;
        GetValueModle * valueModel = [self getValueWithOutPutBlock:[block allBlockInSelf].firstObject];
        model.boolValue = [(NSString *)[[UpdateValueModel sharedValueModel] valueForKey:point] floatValue] > [valueModel.value floatValue];
        
        return model;
    }
    
    NSArray * typeNames = @[@"number_value",@"bool_value",@"colour_value",@"string_value",@"variables_get"];
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
            model.colourValue = [block getBlockValues].firstObject;

            break;
            
        }
        case 3:{
            model.stringValue = [block getBlockValues].firstObject;
            break;
        }
        case 4 : {
            
            NSString * value = [block getTheValueWithName:[block getBlockValues].firstObject];
            
            if (value != nil) {
                
                model.value = value;
            } else {
                model.value = @"0";
            }
            break;
        }
        
            return model;
    }
    
    if ([block.name isEqualToString:@"animate_light"]) {
        
        /// 暂时不写
        return model;

    }
    
    if ([block.name isEqualToString:@"port_in"]) {
        
        NSString * port = [block getBlockValues].firstObject;
        UpdateValueModel * modle = [UpdateValueModel sharedValueModel];
        model.numberValue = [[modle valueForKey:port] doubleValue];
        
        return model;
    }
    
    if ([block.name isEqualToString:@"port_get_type"]) {
        
#warning 先不写
        return model;
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
        return model;

    }
    if ([block.name isEqualToString:@"not_value"]) {
        
        GetValueModle * smodel = [self getValueWithOutPutBlock:block.allBlockInSelf.firstObject];
        model.boolValue = ![smodel.value boolValue];
        return model;

    }
    
    if ([block.name isEqualToString:@"control_compare"]) {
        
        CGFloat number1 = [[self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].value floatValue];
        CGFloat number2 = [[self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].value floatValue];
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
        return model;

    }
    
    if ([block.name isEqualToString:@"and_or"]) {
        
        BOOL bool1 = [[self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].value boolValue];
        bool bool2= [[self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].value boolValue];
        
        NSString * str = [block getBlockValues].firstObject;
        if ([str isEqualToString:@"and"]) {
            
            model.boolValue = (bool1 && bool2);
            
        } else {
            
            model.boolValue = (bool1 || bool2);
        }
        return model;

    }
    
    if ([block.name isEqualToString:@"math_calculator"]) {
        
        CGFloat number1 = [[self getValueWithOutPutBlock:block.allBlockInSelf.firstObject].value floatValue];
        CGFloat number2 = [[self getValueWithOutPutBlock:block.allBlockInSelf.lastObject].value floatValue];
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
        return model;

    }
    
    if ([block.name isEqualToString:@"math_odevity"]) {
        
        CGFloat number = [[self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].value floatValue];
        NSInteger intVale = number;
        
        NSInteger i = intVale % 2;
        NSString * str = [block getBlockValues].firstObject;
        if ([str isEqualToString:@"奇数"]) {
            
            model.boolValue = i==1;
        } else {
            model.boolValue = i==0;
            
        }
        return model;

    }
    
    if ([block.name isEqualToString:@"math_intger"]) {
        
        CGFloat number = [[self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].value floatValue];
        NSInteger interValue = round(number);
        model.numberValue = interValue;
        return model;

    }
    if ([block.name isEqualToString:@"math_cover_to"]) {
        
        CGFloat number = [[self getValueWithOutPutBlock:[block allBlockInSelf].firstObject].value floatValue];
        
        CGFloat rangeDown = [[self getValueWithOutPutBlock:[block allBlockInSelf][1]].value floatValue];
        CGFloat rangeUp = [[self getValueWithOutPutBlock:[block allBlockInSelf][2]].value floatValue];
        
        CGFloat rangeDown1 = [[self getValueWithOutPutBlock:[block allBlockInSelf][3]].value floatValue];
        CGFloat rangeUp1 = [[self getValueWithOutPutBlock:[block allBlockInSelf][4]].value floatValue];
        ///y = A*x +B
        CGFloat lenth1 = rangeUp1 - rangeDown1;
        CGFloat lenth = rangeUp - rangeDown;
        CGFloat A = lenth1 / lenth;
        CGFloat B = (rangeDown1 + lenth1/2) - (rangeDown + lenth/2) * A;
        
        CGFloat newNumber = number * A + B;
        model.numberValue = newNumber;
        return model;

    }
    
    if ([block.name isEqualToString:@"math_cover_proportion"]) {
        
        NSString * port = [block getBlockValues].firstObject;
        CGFloat number = [[[UpdateValueModel sharedValueModel] valueForKey:port] doubleValue];

        
        CGFloat rangeDown = [[self getValueWithOutPutBlock:[block allBlockInSelf][1]].value floatValue];
        CGFloat rangeUp = [[self getValueWithOutPutBlock:[block allBlockInSelf][2]].value floatValue];
        CGFloat lenth = rangeUp - rangeDown;
        CGFloat proport = (number - rangeDown)/lenth;
        model.numberValue = proport;
        return model;
    }
    
    NSLog(@"get valueModel");
    return model;
}

///获取正常情况下的数值
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
    
    [self setValue:@(cvalue) forKey:noti.name];
    
    [[CustomNotificationCenter sharedCenter] removeObserver:self blockName:noti.name values:nil];

    [[BLEControl sharedControl] sendCMDToBluetooth:[NSString stringWithFormat:DEFAULT_OF,point]];
    
    
}

- (void)getWhileOutputCallback {
    
    BKYBlock * root = self.rootBlock;
    
    self.isTrue = [[self getValueWithOutPutBlock:root.allBlockInSelf.firstObject].value boolValue];
    
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
            
//            NSArray * valuesType = @[@"variables_get",@"use_change",@"variable_repetition_num",@"variable_repetition",@"variable_if",@"variable_if_else"];
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
            NSArray * ifTypeNames = @[@"if",@"if_else"];
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
        
        
        NSInteger time = [[self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value integerValue];
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
//    if ([current.name isEqualToString:@"animation_image"]) {
//        
//    }
    
    
    
    if ([current.name containsString:@"light"]) {
    
        newValues = values;
    }
    if ([current.name isEqualToString:@"light_color"]) {
        
        NSString * color = [self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value;
        
        newValues = @[values[0],color];
    }
    
#pragma mark 声音
    if ([@[@"daily_words",@"music_sound",@"animal_sound",@"transport_sound"] containsObject:current.name]) {
        
        NSInteger time = [[self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value floatValue];
        newValues = @[values[0],values[1],@(time),values[2]];
    }
    
    if ([current.name isEqualToString:@"buzzer_level"]) {
     
        NSInteger time = [[self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value floatValue];
        newValues = @[values[0],values[1],values[2],@(time),values[3]];
    }
    
#pragma mark 端口
    if ([current.name isEqualToString:@"port_out"]) {
        
        NSString * point = values[0];
        NSInteger value = [[self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value integerValue];
        
        newValues = @[point,@(value)];
        
    }
    
    if ([current.name isEqualToString:@"port_on_off"]) {
        
        newValues = values;
    }
    
#pragma mark 时间
    if ([current.name isEqualToString:@"wait_port_open"]) {
        newValues = values;
    }
   
    
    if (newValues.count > 0) {
        
        [[CustomNotificationCenter sharedCenter] addObserver:self name:notifitionName callback:@selector(bluetoothCallbcak:) object:nil];
        
        [[BLEControl sharedControl] sendCMDToBluetooth:newValues withBlockName:current.name];
        
    } else {
        
        //无特殊操作block
        if ([current.name isEqualToString:@"do_function"]) {
            
            self.funcCurrent = [BlocklyControl shardControl].functions[[current getBlockValues].firstObject];
            if (self.funcCurrent) {
                
                self.funcCurrent.loopCount = 1;
                self.funcCurrent.superBlock = self;
                [self.funcCurrent runCurrent];
                
            } else {
                
                [NSThread sleepForTimeInterval:self.delay];
            }
            
            return ;
        }
        if ([current.name isEqualToString:@"long_time"]) {
            
            NSArray * values = [current getBlockValues];
            NSInteger time = [[self getValueWithOutPutBlock:current.allBlockInSelf.firstObject].value integerValue];
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
        
        if ([current.name isEqualToString:@"variables_set"]) {
         

            GetValueModle * model = [self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject];
            
            NSString * name = [current getBlockValues].firstObject;
            
            [current setValueWithName:name value:model.value];
            
            [NSThread sleepForTimeInterval:self.delay];


        }
        
        if ([current.name isEqualToString:@"wait_do"]) {
            
            NSArray * values = [current getBlockValues];
            CGFloat value = [[self getValueWithOutPutBlock:[current allBlockInSelf].firstObject].value floatValue];
            self.sound = value;
            newValues = @[values[0]];
        }
        if ([current.name isEqualToString:@"break"]) {
            
            [NSThread sleepForTimeInterval:self.delay];
            [self didBreak];
        }
        
        if ([current.name isEqualToString:@"wait_do"]) {
            
            NSArray * values = [current getBlockValues];
            CGFloat value = [[self getValueWithOutPutBlock:[current allBlockInSelf].firstObject].value floatValue];
            self.sound = value;
            newValues = @[values[0]];
            [self waitDoFunction];
        }
        
        [self.currentBlock.defaultBlockView setDisHighlight];
        [self runNext];
        
    }
    
    
}
///等待端口 wait_do
- (void)waitDoFunction {

    NSString * point = [self.currentBlock getBlockValues][0];
    NSString * str = [self.currentBlock getBlockValues][1];
    CGFloat number = [self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject].value.floatValue;
    BOOL isWait = YES;
    while (isWait) {
        
        CGFloat inNumber = [(NSNumber *)[[UpdateValueModel sharedValueModel] valueForKey:point] floatValue];
        if ([str isEqualToString:@">"]) {
            
            isWait = !(inNumber > number);
            
        } else if ([str isEqualToString:@"<"]) {
        
            isWait = !(inNumber < number);
        }
        
        [NSThread sleepForTimeInterval:0.5];
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
    
    BOOL isTrue = [[self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject].value boolValue];
    
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
    NSInteger index = [rapetType indexOfObject:block.name];
    switch (index) {
        case 0: {
            
            self.isRun = NO;
            
            [self.DOCurrent runCurrent];
            
            break;
        }
        case 1: {
            self.isRun = NO;
            [self.DOCurrent runCurrent];
            
            break;
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
    
    if ([self.currentName isEqualToString:@"wait_do"]) {
        
        ButtonCallback * bCall = (ButtonCallback *)bytes;
        
        NSString * str = [self.currentBlock getBlockValues].lastObject;
        if ([str isEqualToString:@">"]) {
            
            isSuccess = (bCall->value1) > self.sound;
            
        } else if ([str isEqualToString:@"<"]) {
            
            isSuccess = (bCall->value1) > self.sound;
            
        }
        
        if (isSuccess) {
            
            [[CustomNotificationCenter sharedCenter].center removeObserver:self name:noti.name object:nil];
            [NSThread sleepForTimeInterval:self.delay];
            [self.currentBlock.defaultBlockView setDisHighlight];
            [self runNext];
        }
        return ;
    }
    
    if ([@[@"light_color",@"light_on_off"] containsObject:self.currentName]) {
        FiveLenthCallback * callback = (FiveLenthCallback *)bytes;
        
        isSuccess = callback->success == 0x01;
    }
    
    if ([self.currentName containsString:@"sound"]) {
    
        isSuccess = callback->success == 0x01;
        
        NSInteger time = [self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.lastObject].value.integerValue;
        BOOL isMS = [self.currentBlock.getBlockValues.lastObject isEqualToString:@"ms"];
        [NSThread sleepForTimeInterval:isMS?time/1000:time];
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

            CGFloat time = [[self getValueWithOutPutBlock:self.currentBlock.allBlockInSelf.firstObject].value floatValue];
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
        NSArray * typeNames = @[@"if",@"if_else",@"always_repeat",@"repetition_num",@"repetition_until1",@"repetition_for"];
        
        
        
        if ([typeNames containsObject: self.currentName]) {
            
            
            self.currentBlock = self.currentBlock.nextBlock;
            self.isRun = YES;
            [self.condition signal];
        }
        
    }
}

- (void)overRun {
    
    if ([self.rootBlock.name isEqualToString:@"repetition_for"]) {
        
        NSArray * values = [self.rootBlock getBlockValues];

        NSString * str = values.firstObject;
        
        NSArray * inputArray = self.rootBlock.allBlockInSelf;
        CGFloat rangeUp = [[self getValueWithOutPutBlock:inputArray[1]].value floatValue];
        
        self.forNumber = self.forIsTure? self.forNumber + 1 : self.forNumber - 1;
        if (self.forNumber > rangeUp && self.forIsTure) {
            
            self.loopCount = 0;
        } else if (self.forNumber < rangeUp && !self.forIsTure) {
            
            self.loopCount = 0;
        }
        
        CGFloat number = [[self getValueWithOutPutBlock:inputArray[2]].value floatValue];
        CGFloat valueNumber = [[self.rootBlock getTheValueWithName:str] floatValue];
        
        NSArray * array = @[@"+",@"x",@"-",@"÷"];
        NSInteger index = [array indexOfObject:values.lastObject];
        switch (index) {
            case 0: {
                valueNumber += number;
                break;
            }
            case 1: {
                valueNumber *= number;
                break;
            }
            case 2: {
                valueNumber -= number;
                break;
            }
            case 3: {
                if (number !=0) {
                    valueNumber /= number;
                }
                break;
            }
            default:
                break;
        }
        [self.rootBlock setValueWithName:str value:[NSString stringWithFormat:@"%f",valueNumber]];
    }
    if (self.loopCount >=1) {
        
        for (BKYInput * input in self.rootBlock.inputs) {
            
            if ([input.name isEqualToString:@"DO"]) {
                
                self.currentBlock = input.connectedBlock;
            }
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

