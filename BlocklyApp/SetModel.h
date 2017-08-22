//
//  SetModel.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/6.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
//id,name,class_id,remark,sex,mobile,avatar,password

@interface SetModel : NSObject


    ///头像
    @property (nonatomic, copy) NSString * avatar;
    ///昵称
    @property (nonatomic, copy) NSString * name;
    ///性别
    @property (nonatomic, copy) NSString * sex;
    ///电话号码
    @property (nonatomic, copy) NSString * mobile;
    ///程序延迟执行
    @property (nonatomic, copy) NSString * delay;
    ///判断延迟执行
    @property (nonatomic, copy) NSString * ifDelay;
    ///红外线
    @property (nonatomic, copy) NSString * infrared;
    ///声控
    @property (nonatomic, copy) NSString * sound;
    ///超声波
    @property (nonatomic, copy) NSString * waves;
    ///用户ID
    @property (nonatomic, copy) NSString * uid;
    ///班级ID
    @property (nonatomic, copy) NSString * class_id;
    ///备注
    @property (nonatomic, copy) NSString * remark;
    ///token
    @property (nonatomic, copy) NSString * token;
    ///密码
    @property (nonatomic, copy) NSString * password;
    
    
@end
