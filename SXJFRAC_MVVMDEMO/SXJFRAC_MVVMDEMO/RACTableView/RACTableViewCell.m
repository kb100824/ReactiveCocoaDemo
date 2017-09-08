//
//  RACTableViewCell.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACTableViewCell.h"


@interface RACTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_detail;



@end

@implementation RACTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
