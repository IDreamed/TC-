//
//  ValueView.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/27.
//  Copyright © 2017年 text. All rights reserved.
//

#import "ValueView.h"

@interface ValueView ()

@property (weak, nonatomic) IBOutlet UILabel *yuanValue;
@property (weak, nonatomic) IBOutlet UILabel *fangValue;
@property (weak, nonatomic) IBOutlet UILabel *xingValue;
@property (weak, nonatomic) IBOutlet UILabel *sanjiaoValue;

@property (strong, nonatomic) NSDictionary * models;

@property (strong, nonatomic) NSTimer * time;

@end

@implementation ValueView

- (void)dealloc {
    
    if ([self.time isValid]) {
        [self.time invalidate];
    }
}

- (void)setValueModels:(NSDictionary *)models {
    
    self.models = models;

    if (!self.time) {
        self.time = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateValue) userInfo:nil repeats:YES];
    }
    
}

- (void)updateValue {
    
    NSArray * images = @[@"bl_yuan_1",@"bl_fang_1",@"bl_sanjiao_1",@"bl_xingxing_1"];
    NSArray * labels = @[self.yuanValue,self.fangValue,self.sanjiaoValue,self.xingValue];
    if (self.models) {
        
        for (NSString * key in self.models.allKeys) {
            
            ValueModel * model = self.models[key];
            NSInteger index = [images indexOfObject:key];
            NSString * value = [NSString stringWithFormat:@"%.01f",model.value];
            
            UILabel * label = labels[index];
            label.text = value;
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
