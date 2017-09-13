//
//  RACMulticastConnectionRequest.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/13.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACMulticastConnectionRequest : NSObject
/**
 *  RACCommand中4个最重要的信号就是定义开头的那4个信号，executionSignals，executing，enabled，errors。需要注意的是，这4个信号基本都是（并不是完全是）在主线程上执行的
 *  使用RACMulticastConnection来发送网络请求能解决信号每次订阅subscribeNext重复发起一次新的网络请求
 *  @param urlString 接口url
 *  @param successCompleteHandler      请求成功回调
 *  @param failureCompleteHandler      请求失败回调
 */

+ (void)rac_MulticastConnectionRequestWithURLString:(NSString *)urlString
                         rac_SuccessCompleteHandler:(void(^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void(^)(NSError *error))failureCompleteHandler;
@end
