//
//  RACTimerViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/14.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACTimerViewController.h"
#define kCountDownTimerSeconds 20
@interface RACTimerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@end

@implementation RACTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    // 验证码点击
    self.btnTimer.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self);
       
        return [self startTimerSingal:kCountDownTimerSeconds];
    }];



}

- (RACSignal *)startTimerSingal:(NSInteger)timerCountDown{
    
    @weakify(self);
    __block NSInteger countDown = timerCountDown;
    RACSignal *timerSingal = [[[RACSignal interval:1.0f
                                       onScheduler:[RACScheduler mainThreadScheduler]]
                               map:^id (NSDate *  date) {
                                   @strongify(self);
                                   
                                   NSString *tempTitle;
                                   BOOL countCompleted;
                                   
                                   if ((--countDown)<=0) {
                                       self.btnTimer.enabled = YES;
                                       tempTitle = [NSString stringWithFormat:@"%@",@"重新发送验证码"];
                                       countCompleted =  YES;
                                   }else{
                                       self.btnTimer.enabled = NO;
                                       tempTitle =[NSString stringWithFormat:@"%ld秒后重新获取验证码", countDown];
                                       countCompleted =  NO;
                                   }
                                   
                                   [self.btnTimer setTitle:tempTitle forState:UIControlStateNormal];
                                   self.lblTimer.text = tempTitle;
                                   return @(countCompleted);
                               }] takeUntilBlock:^BOOL(id  x) {
                                   
                                   return countDown<=0;
                                   
                               }];
    
    
    return timerSingal;
    
}

@end
