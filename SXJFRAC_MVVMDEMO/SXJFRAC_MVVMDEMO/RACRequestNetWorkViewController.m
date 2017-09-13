//
//  RACRequestNetWorkViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/13.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACRequestNetWorkViewController.h"
#import "RACCommandRequest.h"
#import "RACMulticastConnectionRequest.h"
@interface RACRequestNetWorkViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCommandRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnMulticastConnectionRequest;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Result;

@end

@implementation RACRequestNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    @weakify(self);
    
    [[self.btnMulticastConnectionRequest rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl *  x) {
        //RACMulticastConnection网络请求
        [RACMulticastConnectionRequest rac_MulticastConnectionRequestWithURLString:@"http://www.kuaidi100.com/query?type=yuantong&postid=11111111111" rac_SuccessCompleteHandler:^(NSDictionary *responseObject) {
            NSLog(@"responseObject =%@",responseObject);
            @strongify(self);
            self.lbl_Result.text = @"RACMulticastConnection网络请求成功";
            
        } rac_FailureCompleteHandler:^(NSError *error) {
            @strongify(self);
            self.lbl_Result.text = @"RACMulticastConnection网络请求失败";
            
        } ];

        
        
        
        
    }];
    
    
    [[self.btnCommandRequest rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl *  x) {
        //RACCommand网络请求
        [RACCommandRequest rac_CommandRequestWithURLString:@"http://www.kuaidi100.com/query?type=yuantong&postid=11111111111" rac_SuccessCompleteHandler:^(NSDictionary *responseObject) {
            @strongify(self);
            self.lbl_Result.text = @"RACCommand网络请求成功";
           
            NSLog(@"responseObject =%@",responseObject);
        } rac_FailureCompleteHandler:^(NSError *error) {
            
            @strongify(self);
             self.lbl_Result.text = @"RACCommand网络请求失败";
        }];
        
        
        
        
        
    }];
    

    
    
    
    
    
}



@end
