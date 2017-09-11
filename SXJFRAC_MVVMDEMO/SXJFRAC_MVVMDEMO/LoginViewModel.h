//
//  LoginViewModel.h
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/11.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
@interface LoginViewModel : NSObject

@property(nonatomic,strong) LoginModel *userModel;

@property(nonatomic,strong,readonly) RACCommand *loginCommand;




@end
