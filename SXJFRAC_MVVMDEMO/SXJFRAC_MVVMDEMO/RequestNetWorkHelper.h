//
//  RequestNetWorkHelper.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/11.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestNetWorkHelper : NSObject
/**
 **  模拟网络请求返回一个信号源
 ** @param userName 用户名
 ** @param userPassword  用户密码
 ** @return 返回一个请求结果信号源
 **/
+ (RACSignal *)loginInServiceUserName:(NSString *)userName password:(NSString *)userPassword;
@end
