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
@property(nonatomic,strong)RACDataHelper *dataHelper;

@end

@implementation RACTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataHelper = [[RACDataHelper alloc]initWithCellIndentifier:celIdentifier configureCompleteHandler:^(RACTableViewCell *racCell, RACSignal *modelSingal) {
        [racCell configureBindCellData:modelSingal];
        
    } tableView_DidSelectRowCompleteHandler:^(RACSignal *tableViewSingal) {
        
        [tableViewSingal subscribeNext:^(RACTuple *value) {
            UITableView *tableView = value.first;
            NSIndexPath *indexpath = value.second;
            NSLog(@"SelectRow=%ld\n indexpath=%@",tableView.indexPathForSelectedRow.row,indexpath);
            
        }];
    }];
    
    //刚加载基本数据
    @weakify(self);
    [RACViewModel requestLoadDataCompleteHandler:^(NSArray *tempArray) {
        @strongify(self);
        
        self.dataHelper.dataSoureArray = tempArray;
        
        [self.requestDataArray addObjectsFromArray:tempArray];
        
        
    }];
    
    
    self.rac_tableView.dataSource = self.dataHelper;
    self.rac_tableView.delegate = self.dataHelper;
    
    //模拟添加更多数据
    [RACViewModel requestLoadMoreDataCompleteHandler:^(NSArray *tempArray) {
        
         @strongify(self);
         [self.requestDataArray addObjectsFromArray:tempArray];
        self.dataHelper.dataSoureArray = [self.requestDataArray copy];
        [self.rac_tableView reloadData];
    }];
    
    
    
    
}

- (NSMutableArray *)requestDataArray{
    if (!_requestDataArray) {
        
        _requestDataArray = [NSMutableArray array];
    }
    return _requestDataArray;

}

@end
