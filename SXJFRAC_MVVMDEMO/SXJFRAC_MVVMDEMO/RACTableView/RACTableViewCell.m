//
//  RACTableViewCell.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACTableViewCell.h"
#import "RACModel.h"

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


- (void)configureBindCellData:(RACSignal *)modelSingal{

    
    @weakify(self);
//    [[modelSingal takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(RACModel *rac_Model) {
//        
//        @strongify(self);
//        
//        self.lbl_title.text = rac_Model.title;
//        self.lbl_detail.text = rac_Model.detail;
//
//    }];
    
    
    [modelSingal subscribeNext:^(RACModel *rac_Model) {
        @strongify(self);
        
        self.lbl_title.text = rac_Model.title;
        self.lbl_detail.text = rac_Model.detail;
        
        
        
        
    }];
    
    

}

@end
