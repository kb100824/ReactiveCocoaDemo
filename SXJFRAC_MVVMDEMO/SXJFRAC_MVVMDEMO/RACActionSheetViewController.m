//
//  RACActionSheetViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/15.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACActionSheetViewController.h"

@interface RACActionSheetViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnActionSheet;
@property (weak, nonatomic) IBOutlet UILabel *lblOption;

@end

@implementation RACActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    
    [[self.btnActionSheet rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
         UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:@"取消" otherButtonTitles:@"选项1",@"选项2",@"选项3", nil];
        
        
        [[sheet rac_buttonClickedSignal]subscribeNext:^(NSNumber * index) {
           
            
            NSInteger optionIndex = [index integerValue];
            NSString *optionTitle = nil;
            if (optionIndex==0) {
                optionTitle = @"取消";
            }else if (optionIndex==4){
               optionTitle = @"确定";
            }else{
              optionTitle = [NSString stringWithFormat:@"选项%ld",optionIndex];
            }
            
            self.lblOption.text = optionTitle;
            
            
            
        }];
        [sheet showInView:self.view];
        
        
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
