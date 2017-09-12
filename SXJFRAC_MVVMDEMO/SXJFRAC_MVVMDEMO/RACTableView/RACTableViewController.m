//
//  RACTableViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//
static NSString *celIdentifier = @"RACTableViewCell";
#import "RACTableViewController.h"
#import "RACDataHelper.h"
#import "RACTableViewCell.h"
#import "RACViewModel.h"
@interface RACTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *rac_tableView;

@property(nonatomic,strong)  NSMutableArray *requestDataArray;
@property(nonatomic,strong)  RACDataHelper *dataHelper;

@end

@implementation RACTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    @weakify(self);
    
   
     
    
    
    
    self.dataHelper = [[RACDataHelper alloc]initWithCellIndentifier:celIdentifier configureCompleteHandler:^(RACTableViewCell *racCell, RACSignal *modelSingal) {
        
        
         [racCell configureBindCellData:modelSingal];
        
    } tableView_DidSelectRowCompleteHandler:^(RACSignal *tableViewSingal) {
        [tableViewSingal subscribeNext:^(RACTuple *tuple) {
            //因为是绑定didSelectRowAtIndexPath代理函数只有两个参数所以这只需要first和second
            UITableView *tableView = tuple.first;
            NSIndexPath *indexpath = tuple.second;
            NSLog(@"selectRow=%ld\n indexpath=%@",tableView.indexPathForSelectedRow.row,indexpath);
            
        }];

        
    } deleteCellRowCompleteHandler:^(RACSignal *cellSingal) {
        
        
        [cellSingal subscribeNext:^(RACTuple *celltuple) {
            
            @strongify(self);
            //获取UITableViewCellEditingStyle样式类型
            NSInteger cellCommitStyleType = [celltuple.second integerValue];
            //获取cell当前行
            NSIndexPath *cellIndexPath = celltuple.third;
            if (cellCommitStyleType==UITableViewCellEditingStyleDelete) {
            
               
                if (self.dataHelper.dataSoureArray.count) {
                    [self.dataHelper.dataSoureArray removeObjectAtIndex:cellIndexPath.row];
                    [self.rac_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [self.rac_tableView reloadData];
                    

                }

                
                
            }
            
            
            
            
           
            
        }];
        
        
    }];
    
    //刚加载基本数据
    
    [RACViewModel requestLoadDataCompleteHandler:^(NSArray *tempArray) {
        @strongify(self);
        
       
        
        [self.requestDataArray addObjectsFromArray:tempArray];
       
        
        self.dataHelper.dataSoureArray = self.requestDataArray;
        
    }];
    
    
    self.rac_tableView.dataSource = self.dataHelper;
    self.rac_tableView.delegate = self.dataHelper;
    
       
    
    
    
}

- (NSMutableArray *)requestDataArray{
    if (!_requestDataArray) {
        
        _requestDataArray = [NSMutableArray array];
    }
    return _requestDataArray;

}

@end
