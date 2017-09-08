//
//  RACViewModel.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACViewModel.h"
#import "RACModel.h"
@interface RACViewModel()


@end
@implementation RACViewModel




+ (void)requestLoadDataCompleteHandler:(void (^)(NSArray *))dataCompleteHandler{

    
    

   
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray removeAllObjects];
    for (NSInteger i =0; i<10; i++) {
        
        RACModel *model = [RACModel new];
        model.title = [NSString stringWithFormat:@"title_%ld",i];
        model.detail = [NSString stringWithFormat:@"detail_%ld",i];
        
        [tempArray addObject:model];
        
        
    }
    
    if (dataCompleteHandler) {
        dataCompleteHandler([tempArray copy]);
    }
    
    

}
+ (void)requestLoadMoreDataCompleteHandler:(void(^)(NSArray *tempArray))dataCompleteHandler{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray removeAllObjects];
        for (NSInteger i =11; i<100; i++) {
            
            RACModel *model = [RACModel new];
            model.title = [NSString stringWithFormat:@"title_%ld",i];
            model.detail = [NSString stringWithFormat:@"detail_%ld",i];
            
            [tempArray addObject:model];
            
            
        }
        
        if (dataCompleteHandler) {
            dataCompleteHandler([tempArray copy]);
        }
        

        
        
    });

}


@end
