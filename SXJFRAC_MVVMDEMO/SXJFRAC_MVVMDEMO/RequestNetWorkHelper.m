//
//  RequestNetWorkHelper.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/11.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RequestNetWorkHelper.h"

@implementation RequestNetWorkHelper
+ (RACSignal *)loginInServiceUserName:(NSString *)userName password:(NSString *)userPassword{


    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>   subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([userName isEqualToString:@"1234"]&&[userPassword isEqualToString:@"1234"]) {
                
                [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!",userName, userPassword]];
                [subscriber sendCompleted];
                
                
            }else{
            
            
                [subscriber sendError:[NSError errorWithDomain:@"登录失败用户名或者密码错误" code:1001 userInfo:nil]];
                
                
                
            }
            
            
            
        });
       
        return nil;
    }];

}
@end
