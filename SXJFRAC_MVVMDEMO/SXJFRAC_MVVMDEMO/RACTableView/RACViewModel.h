//
//  RACViewModel.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACViewModel : NSObject
//模拟请求加载数据
+ (void)requestLoadDataCompleteHandler:(void(^)(NSArray *))dataCompleteHandler;
//模拟请求加载更多数据
+ (void)requestLoadMoreDataCompleteHandler:(void(^)(NSArray *tempArray))dataCompleteHandler;

@end
