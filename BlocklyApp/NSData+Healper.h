//
//  NSData+Healper.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/9.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Healper)

    ///16进制字符串转NSData
    + (NSData*) hexToBytes:(NSString *)str;
    
    - (NSData *)returnSumValue;
    
@end
