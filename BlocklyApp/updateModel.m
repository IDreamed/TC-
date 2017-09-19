//
//  updateModel.m
//  BlocklyApp
//
//  Created by 张 on 2017/9/13.
//  Copyright © 2017年 text. All rights reserved.
//

#import "updateModel.h"

@implementation updateModel

static updateModel * model;

+ (void)setModel:(updateModel *)model {
    
    model = model;
}

+ (updateModel *)getModel {
    
    if (!model) {
        
        model = [[updateModel alloc] init];
    }
    
    return model;
}

@end
