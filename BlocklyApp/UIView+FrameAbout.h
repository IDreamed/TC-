//
//  UIView+FrameAbout.h
//  TC text
//
//  Created by 张 on 2017/6/29.
//  Copyright © 2017年 text. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameAbout)

///frame的x
@property (assign, nonatomic) CGFloat x;
///frame的y
@property (assign, nonatomic) CGFloat y;
///frame的width
@property (assign, nonatomic) CGFloat width;
///frame的height
@property (assign, nonatomic) CGFloat height;
///中心点x
@property (assign, nonatomic) CGFloat centerX;
///中心点y
@property (assign, nonatomic) CGFloat centerY;
///大小
@property (assign, nonatomic) CGSize size;

- (void)addConstraintsWithViews:(NSDictionary *)views formoats:(NSArray *)formats metrics:(NSDictionary *)metrics;

- (void)touchBeginWith:(UIView *)view point:(CGPoint)point;

- (void)touchMoveWith:(UIView *)view point:(CGPoint)point;

- (void)touchEndWith:(UIView *)view point:(CGPoint)point;

- (void)touchCancellWith:(UIView *)view point:(CGPoint)point;

@end
