//
//  RACTableViewCell.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACTableViewCell : UITableViewCell
/**
 ** @param modelSingal 信号源订阅遍历对应的model刷新UI控件
 */
- (void)configureBindCellData:(RACSignal *)modelSingal;
@end
