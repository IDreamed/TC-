//
//  HTTPRequest.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/7.
//  Copyright © 2017年 text. All rights reserved.
//

#import "HTTPRequest.h"
#import "CustomHUD.h"
#import <QiniuSDK.h>
#import "APPControll.h"

//#define BASE_URL @"http://qihuanrobot.com/index.php?"
#define BASE_URL @"https://api.tongyishidai.com?"

//http://qihuanrobot.com/index.php?g=portal&m=app&a=return_version
#define BASE_URL_TEST @"http://192.168.3.85:8181/jeesite/a/"

#define HEAD_KEY  @"headimage_"

@implementation HTTPRequest

+ (instancetype)sharedHttpRequest {
    
    static HTTPRequest * request;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (request == nil) {
            
            request = [[HTTPRequest alloc] init];
        }
        
    });
    
    return  request;
}
    
- (void)getUrl:(NSString *)url parameter:(NSDictionary *)para progress:(ProgressCallback)press success:(SuccessCallback)success failure:(FailureCallback)failure {
    
    NSString * newUrl = [BASE_URL stringByAppendingString:url];
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:newUrl parameters:para progress:press success:success failure:failure];
    
}

- (void)postUrl:(NSString *)url parameter:(NSDictionary *)para progress:(ProgressCallback)press success:(SuccessCallback)success failure:(FailureCallback)failure {
    
    NSString * newUrl = [BASE_URL stringByAppendingString:url];

    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [CustomHUD showwithTextDailog:nil];
    [manager POST:newUrl parameters:para progress:press success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([data[@"status"] integerValue] == 1) {
        
            if (success) {
                
                success(task,data);
            }
        }
        
        [CustomHUD showText:data[@"info"]];
//        [CustomHUD hidenHUD];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [CustomHUD hidenHUD];
        if (failure) {
            
            failure(task, error);
        }
    }];
}
    
- (void)postHrardImageWidthcallback:(void(^)(NSString * str))callback
{
    if (!self.image) {
        
        return ;
    }
    
    NSData * data = UIImageJPEGRepresentation(self.image, 0.5);
    
    SetModel * mode = [APPControll getUserInfo];
    
    [self postUrl:@"g=portal&m=app&a=getUploadtoken" parameter:@{@"token":mode.token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * uploadToken = responseObject[@"data"][@"upload_token"];
        NSString * link = responseObject[@"data"][@"link"];
        QNUploadManager * upManager = [[QNUploadManager alloc] init];
//        NSString * key = [NSString stringWithFormat:@"%@%@",HEAD_KEY,mode.uid];
        [upManager putData:data key:nil token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
           
            NSString * imagePath = [link stringByAppendingPathComponent:resp[@"hash"]];
            if (callback) {
                
                callback(imagePath);
            }
            
        } option:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CustomHUD showText:@"上传失败请重试"];
    }];
    
}

@end
