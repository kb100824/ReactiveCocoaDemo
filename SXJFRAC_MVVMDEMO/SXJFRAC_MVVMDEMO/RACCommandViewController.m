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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *lblRemind;

@end

@implementation RACCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.indicatorView.hidden = YES;
    _loginViewModel = [LoginViewModel new ];
    
    RAC(self.loginViewModel,userModel.userName) = self.textField_UserName.rac_textSignal;
    RAC(self.loginViewModel,userModel.userPassWord) = self.textField_UserPwd.rac_textSignal;
   
    self.btnLogin.rac_command = self.loginViewModel.loginCommand;
  
    @weakify(self);
    [[self.loginViewModel.loginCommand executionSignals]subscribeNext:^(RACSignal *x) {
        @strongify(self);
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
        self.lblRemind.text = @"登录请求中...";
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [x subscribeNext:^(id  _Nullable x) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.indicatorView.hidden = YES;
            self.lblRemind.text = @"登录成功";
            [self.indicatorView stopAnimating];
        }];
        
        
        
        
    }];
    
    [self.loginViewModel.loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"ERROR! --> %@",x);
        self.indicatorView.hidden = YES;
        self.lblRemind.text = @"用户名或者密码错误，登录失败";
        [self.indicatorView stopAnimating];
        
    }];
    
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    [self.view endEditing:YES];
}

@end
