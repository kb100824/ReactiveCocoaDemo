//
//  RACSecondViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/12.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACSecondViewController.h"

@interface RACSecondViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPop;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation RACSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    @weakify(self);
    [[self.btnPop rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl *  x) {
        @strongify(self);
        
        if (_delegateSubject) {
           
            [_delegateSubject sendNext:self.textField.text];
            [_delegateSubject sendCompleted];
        }
        
        
        if (_racDelegate&&[_racDelegate respondsToSelector:@selector(testRACSubjectDelegate:)]) {
            
            [_racDelegate testRACSubjectDelegate:self.view];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }];
    
    
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];

}
@end
