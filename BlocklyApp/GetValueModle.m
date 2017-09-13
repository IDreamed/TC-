
//
//  GetValueModle.m
//  BlocklyApp
//
//  Created by 张 on 2017/8/23.
//  Copyright © 2017年 text. All rights reserved.
//

#import "GetValueModle.h"

@implementation GetValueModle

- (instancetype)init {
    
    if (self = [super init]) {
        self.numberValue = 0;
        self.boolValue = NO;
        self.stringValue = @"";
        self.colourValue = @"777777";
        
    }
    return self;
}

- (void)setBoolValue:(BOOL)boolValue {
    
    _boolValue = boolValue;
    
    self.value = [NSString stringWithFormat:@"%d",boolValue];
}

- (void)setColourValue:(NSString *)colourValue {
    _colourValue = colourValue;
    self.value = colourValue;
}

- (void)setNumberValue:(CGFloat)numberValue {
    _numberValue = numberValue;
    self.value = [NSString stringWithFormat:@"%f",numberValue];
}

- (void)setStringValue:(NSString *)stringValue {
    _stringValue = stringValue;
    
    self.value = stringValue;
}

- (void)setValueName:(NSString *)valueName {
    _valueName = valueName;
    self.value = valueName;
}

- (void)getvalueForSelf {

    
}

@end
