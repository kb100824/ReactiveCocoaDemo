//
//  RACRefreshControlViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/15.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACRefreshControlViewController.h"

@interface RACRefreshControlViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *refreshScrollerview;

@end

@implementation RACRefreshControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIRefreshControl *refreshControl  = [[UIRefreshControl alloc]init];
    //设置刷新控件颜色
    RAC(refreshControl, tintColor) = [RACObserve(self.refreshScrollerview, contentOffset) map:^id (NSNumber   *value) {
        
        CGPoint piont = [value CGPointValue];
        return piont.y<0.0?[UIColor redColor]:[UIColor yellowColor];
        
    }];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIRefreshControl *refreshControl) {
        
        //模拟网络请求
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            
            [refreshControl endRefreshing];
            
        }];
        
    }];
    

    if(NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_9_x_Max){
    self.refreshScrollerview.refreshControl = refreshControl;
    }
    
    
    
    
}






@end
