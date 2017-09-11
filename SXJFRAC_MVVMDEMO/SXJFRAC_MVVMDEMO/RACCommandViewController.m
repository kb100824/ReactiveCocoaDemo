//
//  RACCommandViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/11.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACCommandViewController.h"
#import "LoginViewModel.h"
@interface RACCommandViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField_UserName;
@property (weak, nonatomic) IBOutlet UITextField *textField_UserPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property(nonatomic,strong) LoginViewModel *loginViewModel;

@end

@implementation RACCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _loginViewModel = [LoginViewModel new ];
    
    RAC(self.loginViewModel,userModel.userName) = self.textField_UserName.rac_textSignal;
    RAC(self.loginViewModel,userModel.userPassWord) = self.textField_UserPwd.rac_textSignal;
   
    self.btnLogin.rac_command = self.loginViewModel.loginCommand;
  
    [[self.loginViewModel.loginCommand executionSignals]subscribeNext:^(RACSignal *x) {
      
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [x subscribeNext:^(id  _Nullable x) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     
            
        }];
        
        
        
        
    }];
    
    [self.loginViewModel.loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"ERROR! --> %@",x);
        
    }];
    
    
    
    
    
}


@end
