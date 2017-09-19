//
//  UIView+FrameAbout.m
//  TC text
//
//  Created by 张 on 2017/6/29.
//  Copyright © 2017年 text. All rights reserved.
//

#import "UIView+FrameAbout.h"

@implementation UIView (FrameAbout)

- (void)setX:(CGFloat)x {
    
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setSize:(CGSize)size {

    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGSize)size {

    return self.frame.size;
}

- (void)addConstraintsWithViews:(NSDictionary*)views formoats:(NSArray *)formats metrics:(NSDictionary *)metrics {
    
    for (NSString * format in formats) {
        
        NSArray * layouts = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
        [self addConstraints:layouts];
        
    }
}

- (void)touchBeginWith:(UIView *)view point:(CGPoint)point {

}
- (void)touchMoveWith:(UIView *)view point:(CGPoint)point {
    
}
- (void)touchEndWith:(UIView *)view point:(CGPoint)point {
    
}

- (void)touchCancellWith:(UIView *)view point:(CGPoint)point {
    
}

@end
