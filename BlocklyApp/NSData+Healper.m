//
//  NSData+Healper.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/9.
//  Copyright © 2017年 text. All rights reserved.
//

#import "NSData+Healper.h"

@implementation NSData (Healper)

    
    + (NSData*) hexToBytes:(NSString *)str{
        NSMutableData* data = [NSMutableData data];
        int idx;
        for (idx = 0; idx+2 <= str.length; idx+=2) {
            NSRange range = NSMakeRange(idx, 2);
            NSString* hexStr = [str substringWithRange:range];
            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        return data;
    }
    
    - (NSData *)returnSumValue {
        
        unsigned char sum = 0;
        
        char * array = self.bytes;
        
        for (int i=0; i<self.length; i++) {
            
           unsigned char j = array[i];
            
//            NSLog(@"%x",j);
            
            sum += j;
//             NSLog(@"%x",sum);
        }
        
        NSString * string = [NSString stringWithFormat:@"%02lx",(long)sum];
        NSData * data = [NSData hexToBytes:string];
        
        return data;
    }
    
@end
