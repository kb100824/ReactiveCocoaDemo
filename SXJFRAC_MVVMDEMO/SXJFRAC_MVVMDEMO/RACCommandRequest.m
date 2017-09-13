//
//  RACCommandRequest.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/13.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACCommandRequest.h"

@implementation RACCommandRequest

+ (void)rac_CommandRequestWithURLString:(NSString *)urlString rac_SuccessCompleteHandler:(void (^)(NSDictionary *))successCompleteHandler rac_FailureCompleteHandler:(void (^)(NSError *))failureCompleteHandler{

    RACCommand *raccommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * (id   input) {
        
        return [[RACSignal createSignal:^RACDisposable * (id<RACSubscriber>   subscriber) {
            
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
           
         return  [RACDisposable disposableWithBlock:^{
                
             [dataTask cancel];
            }]; //保证信号源主线程执行，不然导致ui无法刷新
        }] deliverOn:[RACScheduler mainThreadScheduler]];
    }];
    
    [raccommand.executionSignals subscribeNext:^(RACSignal *singal) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [singal subscribeNext:^(NSDictionary *resultDict) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            if (successCompleteHandler) {
                successCompleteHandler(resultDict);
            }
            
            
            
        }];
        
    }];
    
    [raccommand.errors subscribeNext:^(NSError *error) {
        
        if (failureCompleteHandler) {
            failureCompleteHandler(error);
        }


        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       
    }];
    
    [raccommand execute:@"test"];

}
@end
