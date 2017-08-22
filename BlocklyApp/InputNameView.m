//
//  InputNameView.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/25.
//  Copyright © 2017年 text. All rights reserved.
//

#import "InputNameView.h"

@interface InputNameView ()


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) id target;

@property (assign, nonatomic) SEL action;

@end

@implementation InputNameView


- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 10;
    
    [APPControll registForKeybordNotificationWithObserver:self showAction:@selector(keybordShow:) hidenAction:@selector(keybordHidden)];
    
}

- (void)dealloc {
    
    [APPControll removeKeybordNotificationWithObserver:self];
}

- (void)addEnterTarget:(id)target Action:(SEL)action {
    
    self.target = target;
    self.action = action;
}

- (IBAction)buttonClink:(id)sender {
    
    [self endEditing:YES];
    
    if (self.nameText.text.length == 0) {
        
        [CustomHUD showText:self.titlLabel.text];
        return ;
    }
    
    if (self.target) {
        
        [self.target performSelector:self.action withObject:self.nameText.text];
        [self removeFromSuperview];
    }
}

- (void)keybordShow:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backView.center = CGPointMake(self.backView.center.x, self.center.y - 40);

    }];
}

- (void)keybordHidden {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backView.center = CGPointMake(self.backView.center.x, self.center.y);

    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.backView.frame, point)) {
        
        [self endEditing:YES];
        return ;
    }
    
    [self removeFromSuperview];
}
- (IBAction)cancelClink:(id)sender {
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
