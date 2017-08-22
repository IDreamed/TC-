//
//  CreateBlockly.h
//  Blockly For iOS
//
//  Created by 张 on 2017/5/23.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlocklyToolBoxHealper : NSObject
    
    @property (assign ,nonatomic) NSInteger live;

+ (NSArray *)loadJSONArray;

+ (NSString *)loadToolBoxStringWithIsHigh:(BOOL)isHigh;
    

@end
