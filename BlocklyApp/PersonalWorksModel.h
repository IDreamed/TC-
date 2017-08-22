//
//  PersonalWorksModel.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/26.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalWorksModel : NSObject

///作品ID
@property (nonatomic, copy) NSString * wid;
///block内容
@property (nonatomic, copy) NSString * content;
///创建时间
@property (nonatomic, copy) NSString * createtime;
///标题
@property (nonatomic, copy) NSString * title;
///0 启蒙 1 进阶
@property (nonatomic, assign) NSInteger type;
///type为1时的区分
@property (nonatomic, assign) NSInteger level;

///用户ID
@property (nonatomic, copy) NSString * uid;




@end
