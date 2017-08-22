//
//  CurrentBlock.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentBlock : NSObject

///当前block的name
@property (copy, nonatomic) NSString * _Nullable currentName;
///当前block
@property (strong, nonatomic) BKYBlock * currentBlock;
///该blocktree根节点
@property (strong, nonatomic) BKYBlock * rootBlock;
///父currentblock
@property (weak, nonatomic) CurrentBlock * superBlock;
///DO分支的Currentblock对象
@property (strong, nonatomic) CurrentBlock * DOCurrent;
///ELSE分支的Currentblock对象
@property (strong, nonatomic) CurrentBlock * ELSECurrent;
///函数调用
@property (strong, nonatomic) CurrentBlock * funcCurrent;
///重复的对象
@property (strong, nonnull) CurrentBlock * loopCurrent;
///重复次数 0不重复  maxInteger 一直重复
@property (assign, nonatomic) NSInteger loopCount;
///重复直到

///当前control中是否在运行
@property (assign, atomic) BOOL isRun;



- (void)runCurrent;

- (void)endRun;

- (void)didFinishCurrentBlock:(CurrentBlock *)currentBlock;


@end
