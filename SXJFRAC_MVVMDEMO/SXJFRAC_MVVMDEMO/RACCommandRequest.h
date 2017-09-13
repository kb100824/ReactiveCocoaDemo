//
//  RACCommandRequest.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/13.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACCommandRequest : NSObject
/**
 *  使用RACCommand来发送网络请求
 *  @param urlString 接口url
 *  @param successCompleteHandler      请求成功回调
 *  @param failureCompleteHandler      请求失败回调
 */

+ (void)rac_CommandRequestWithURLString:(NSString *)urlString
                         rac_SuccessCompleteHandler:(void(^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void(^)(NSError *error))failureCompleteHandler;
@end
