//
//  LoginViewModel.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/11.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "LoginViewModel.h"
#import "RequestNetWorkHelper.h"

@interface LoginViewModel ()

@end
@implementation LoginViewModel


- (instancetype)init{

    if (self = [super init]) {
        
        
        _userModel = [LoginModel new];
        
        RACSignal *userNameLengthSingal = [RACObserve(self, userModel.userName) map:^id (NSString *userName) {
            
            return userName.length>3?@(YES):@(NO);
            
        }];
        
        RACSignal *userPwdLengthSingal = [RACObserve(self, userModel.userPassWord) map:^id (NSString *userPwd) {
            
            return userPwd.length>3?@(YES):@(NO);
        }];
        
         RACSignal *loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSingal,userPwdLengthSingal] reduce:^id(NSNumber *userName, NSNumber *password){
             return @([userName boolValue] && [password boolValue]);
            
        }];
        
        @weakify(self);
        _loginCommand = [[RACCommand alloc]initWithEnabled:loginBtnEnable signalBlock:^RACSignal * _Nonnull(id   input) {
            @strongify(self);
            return [RequestNetWorkHelper loginInServiceUserName:self.userModel.userName password:self.userModel.userPassWord];
        }];
        
    }
    return self;
    
    
    
}


@end
