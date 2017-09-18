//
//  RACDatePickerViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/18.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACDatePickerViewController.h"

@interface RACDatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;

@end

@implementation RACDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //信号双向绑定
    RACChannelTerminal *dateTerminal = [self.datePicker rac_newDateChannelWithNilValue:[NSDate date]];
    RACChannelTerminal *textTerminal = [self.textFieldDate rac_newTextChannel];
    
    [[dateTerminal map:^id (id   value) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [dateFormatter stringFromDate:value];
        
    }]subscribe:textTerminal];
    
    
    
    
}


@end
