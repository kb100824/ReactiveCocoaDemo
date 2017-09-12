//
//  RACSecondViewController.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/12.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSubjectDelegate;
@protocol RACSubjectDelegate <NSObject>
@optional;
- (void)testRACSubjectDelegate:(UIView*)currentView;

@end

@interface RACSecondViewController : UIViewController
//用于传值
@property(nonatomic,strong)RACSubject *delegateSubject;

@property(nonatomic,weak)id<RACSubjectDelegate>racDelegate;

@end
