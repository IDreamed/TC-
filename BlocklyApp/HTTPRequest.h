//
//  HTTPRequest.h
//  BlocklyApp
//
//  Created by 张 on 2017/6/7.
//  Copyright © 2017年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "CustomHUD.h"

typedef void(^ProgressCallback)(NSProgress * _Nonnull downloadProgress);
typedef void(^SuccessCallback)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^VersionCallback)(NSDictionary * _Nullable versionInfo);

typedef void(^FailureCallback)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@interface HTTPRequest : NSObject
    
    ///image临时存储区
    @property (nonatomic, strong) UIImage * _Nullable image;

+ (instancetype _Nullable )sharedHttpRequest;

    
- (void)getUrl:(NSString *_Nullable)url parameter:(NSDictionary *_Nullable)para progress:(ProgressCallback _Nullable )press success:(SuccessCallback _Nullable )success failure:(FailureCallback _Nullable)failure;
    
- (void)postUrl:(NSString *_Nullable)url parameter:(NSDictionary *_Nullable)para progress:(ProgressCallback _Nullable )press success:(SuccessCallback _Nullable )success failure:(FailureCallback _Nullable)failure;

- (void)postHrardImageWidthcallback:(void(^)(NSString * str))callback;

- (void)checkAppType:(NSInteger)type VersionWithCallback:(VersionCallback _Nullable )callback;
+ (NSInteger)getAppType;
@end
