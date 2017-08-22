//
//  CreateBlockly.m
//  Blockly For iOS
//
//  Created by 张 on 2017/5/23.
//  Copyright © 2017年 text. All rights reserved.
//

#import "BlocklyToolBoxHealper.h"

@implementation BlocklyToolBoxHealper

static BlocklyToolBoxHealper * blocklyControl;

//加载blockly的json模型
+ (NSArray *)loadJSONArray
{
    
#warning 写死的 需要读取文件
   NSArray * boxs = @[@"control_blocks.json",@"light_blocks.json",@"machine_blocks.json",@"math_blocks.json",@"port_control_blocks.json",@"sound_blocks.json",@"start_blocks.json",@"timer_blocks.json",@"variable_blocks.json",@"event_blocks.json"];
    ///@"control_blocks.json",@"light_blocks.json",@"machine_blocks.json",@"math_blocks.json",@"port_control_blocks.json",@"sound_blocks.json",@"start_blocks.json",@"timer_blocks.json",@"variable_blocks.json"]
    return boxs;
}

+ (NSString *)loadToolBoxStringWithIsHigh:(BOOL)isHigh
{
    NSString * name = [NSString stringWithFormat:@"toolBox%d",isHigh];
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
    
    NSError * error = nil;
    
    NSString * toolBoxString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return  nil;
    }
    
    return toolBoxString;
}

#pragma mark -----bolckly读存相关-------
//- (void)toXMLFile
//{
//    NSError * error = nil;
//    NSString * XMLString =  [self.workbenchViewController.workspace toXMLWithError:&error];
//    
//    if (error) {
//        
//        NSLog(@"%@", error);
//    } else {
//        
//        NSLog(@"%@",XMLString);
//    }
//    
//    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XMLFile.xml"];
//    
//    
//    
//    //    [XMLString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    XMLString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self.workbenchViewController.workspace loadBlocksFromXMLString:XMLString factory:self.workbenchViewController.blockFactory error:&error];
//    NSLog(@"%@",path);
//    
//}


@end
