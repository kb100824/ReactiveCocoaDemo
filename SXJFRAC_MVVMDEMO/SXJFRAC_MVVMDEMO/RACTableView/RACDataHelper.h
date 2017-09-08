//
//  RACDataHelper.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACTableViewCell;
//返回cell,以及数据信号源
 typedef void(^RAC_ConfigureCompleteHandler)(RACTableViewCell *racCell,RACSignal *modelSingal);

@interface RACDataHelper : NSObject<UITableViewDelegate,UITableViewDataSource>

//接收模拟网络请求回来的数据
@property(nonatomic,copy) NSArray *dataSoureArray;

/**
 **  
 ** @param cellIndentifier cell复用标识符
 ** @rac_CompleteHandler  block回调
 */
- (instancetype)initWithCellIndentifier:(NSString *)cellIndentifier configureCompleteHandler:(RAC_ConfigureCompleteHandler)rac_CompleteHandler;



@end
