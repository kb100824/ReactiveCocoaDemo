//
//  RACMulticastConnectionRequest.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/13.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACMulticastConnectionRequest.h"

@implementation RACMulticastConnectionRequest
+ (void)rac_MulticastConnectionRequestWithURLString:(NSString *)urlString rac_SuccessCompleteHandler:(void (^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void (^)(NSError *))failureCompleteHandler{
   
    
      NSAssert(urlString,@"请设置好服务器接口url");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    RACMulticastConnection *connection = [[[RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *urlsession = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [urlsession dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
            if (error) {
                [subscriber sendError:error];
            }else{
              
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [subscriber sendNext:resultDict];
                [subscriber sendCompleted];
            
            }
            
            
            
            
        }];
        [dataTask resume];
        
        
        
        
        return [RACDisposable disposableWithBlock:^{
            
            [dataTask cancel];
            
        }]; //保证信号源主线程执行，不然导致ui无法刷新
    }] deliverOn:[RACScheduler mainThreadScheduler]]publish];
    
    
    [connection.signal  subscribeNext:^(NSDictionary *resultDict) {
        if (successCompleteHandler) {
            successCompleteHandler(resultDict);
        }
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [connection.signal subscribeError:^(NSError *  error) {
       
        if (failureCompleteHandler) {
            failureCompleteHandler(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
    
    
    [connection connect];
    
    


}
@end
