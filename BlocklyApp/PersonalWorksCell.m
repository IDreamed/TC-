//
//  PersonalWorksCell.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/7.
//  Copyright © 2017年 text. All rights reserved.
//

#import "PersonalWorksCell.h"

@interface PersonalWorksCell ()
    
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
    
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation PersonalWorksCell

    
- (IBAction)deleteClink:(id)sender {
    
    __weak PersonalWorksCell * cell = self;
    
    if (self.deleteCallback) {
        
        self.deleteCallback(cell);
    }
    
}

- (void)updateValueWithModel:(PersonalWorksModel *)model {
    
    self.model = model;
    
    NSArray * images = @[@"grzp_fengmian_1", @"grzp_fengmian_2", @"grzp_fengmian_3", @"grzp_fengmian_4", @"grzp_fengmian_5", @"grzp_fengmian_6", @"grzp_fengmian_7", @"grzp_fengmian_8"];
    self.titleLabel.text = model.title;
    self.iconImageVIew.image = [UIImage imageNamed:images[arc4random()%8]];
    
    NSTimeInterval time = [model.createtime doubleValue];
    self.timeLabel.text = [self returnTimeStringWithTimeInterval:time format:@"YYYY.MM.dd"];
    
    
}

- (NSString *)returnTimeStringWithTimeInterval:(NSTimeInterval)time format:(NSString *)format {
    
    NSDateFormatter * form = [[NSDateFormatter alloc] init];
    form.dateFormat = format;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString * times = [form stringFromDate:date];
    
    return times;
}
    
@end
