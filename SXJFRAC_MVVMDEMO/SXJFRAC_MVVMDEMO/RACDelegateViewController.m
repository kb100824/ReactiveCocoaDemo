//
//  RACDelegateViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/12.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACDelegateViewController.h"
#import "RACSecondViewController.h"
@interface RACDelegateViewController ()<RACSubjectDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbl_Delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnPush;

@end

@implementation RACDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(testRACSubjectDelegate:) fromProtocol:@protocol(RACSubjectDelegate)]subscribeNext:^(RACTuple * tuple) {
        //@strongify(self);
        UIView *tempView = self.view;
        
        tempView.backgroundColor = [UIColor yellowColor];
        
        
        NSLog(@"tuple=%@",tuple);
    }];
    

    
    [[self.btnPush rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        @strongify(self);
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RACSecondViewController *secondCtl = [sb instantiateViewControllerWithIdentifier:@"RACSecondViewController"];
        
        secondCtl.delegateSubject = [RACSubject subject];
        secondCtl.racDelegate = self;
        [secondCtl.delegateSubject subscribeNext:^(id  _Nullable x) {
            
            self.lbl_Delegate.text = x;
        }];
        
        [self.navigationController pushViewController:secondCtl animated:YES];
        
    
    }];
    
    
    
}

@end
