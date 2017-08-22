
//
//  SetTableCell.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "SetTableCell.h"

#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HTTPRequest.h"

@interface SetTableCell() <UITextFieldDelegate>
    
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputWidth;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *heardImageWidth;
    @property (assign, nonatomic) NSInteger type;//0头像 1昵称 2性别 3数字
    @property (strong, nonatomic) NSMutableArray * ivasArray;
    @property (assign, nonatomic) NSInteger index;

@end

@implementation SetTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.inputView.delegate = self;

    //头像切圆角
    self.heardImageView.layer.masksToBounds = YES;
    self.heardImageView.layer.cornerRadius = 30;

}

- (void)updateCellWithName:(NSString *)name index:(NSInteger)index{
    
    
    if (!self.ivasArray) {
    
        unsigned int outCount = 0;
        NSMutableArray * ivas = [NSMutableArray array];
        Ivar * ivars = class_copyIvarList([SetModel class], &outCount);
        
        for (unsigned int i=0; i<outCount; i++) {
            
            Ivar iv = ivars[i];
            const char * ivname = ivar_getName(iv);
            
            NSString * string = [NSString stringWithUTF8String:ivname];
            [ivas addObject:string];
            
        }
        self.ivasArray = ivas;
        
    }
    self.index = index;
    self.nameLabel.text = name;
    
    self.heardImageWidth.constant = 0;
    self.inputView.hidden = NO;
    self.type = 3;
    self.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    NSString * key = self.ivasArray[index];
    
    if ([name isEqualToString:@"头像"]) {
        
        self.heardImageWidth.constant = 60;
        self.inputView.hidden = YES;
        self.type = 0;
        NSString * imageName = [self.model valueForKey:key];
        
        if (imageName.length == 0) {
            
            self.heardImageView.image = [UIImage imageNamed:@"touxiang"];
        } else {
            
            [self.heardImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        }
        
        if ([HTTPRequest sharedHttpRequest].image) {
            
            self.heardImageView.image = [HTTPRequest sharedHttpRequest].image;
            
        }
        
    }
    
    if ([name isEqualToString:@"昵称"]) {
        self.inputView.keyboardType = UIKeyboardTypeDefault;
        self.type = 1;
    }
    
    self.inputView.text = [self.model valueForKey:key];
    
    if ([name isEqualToString:@"性别"]) {
        self.inputView.userInteractionEnabled = NO;
        self.inputView.text = self.model.sex.integerValue ? @"女":@"男";
    }
    
    
    
    
}
    
//textfiled代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.type == 3) {
        
        NSString *CM_NUM = @"^[0-9]*$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:string];
    
        if (isMatch1) {
            
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}
    
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.model setValue:textField.text forKey:self.ivasArray[self.index]];
    
    return YES;
}
    
//- (NSInteger)getSelfRow
//{
//    UITableView * table = [self getSelfTable:self];
//    
//    if (table) {
//        NSIndexPath * index = [table indexPathForCell:self];
//        return index.row;
//    }
//    
//    return 0;
//}
//    
//- (UITableView * )getSelfTable:(UIView *)view {
//    
//    UIView * sview = view.superview;
//    
//    if ([sview isKindOfClass:[UITableView class]]) {
//        
//        return  (UITableView *)sview;
//    } else {
//        
//        return [self getSelfTable:sview];
//    }
//    
//    return nil;
//}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
