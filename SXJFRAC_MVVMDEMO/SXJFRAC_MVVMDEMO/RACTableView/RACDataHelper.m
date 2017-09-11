//
//  RACDataHelper.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "RACDataHelper.h"
#import "RACTableViewCell.h"
@interface RACDataHelper ()
{
    RAC_ConfigureCompleteHandler tempCompleteHandler;
    RACSignal *dataSingal;
    NSString *tempCellIndentifier;
}




@end
@implementation RACDataHelper

- (NSMutableArray *)dataSoureArray{

    if (!_dataSoureArray) {
        _dataSoureArray = [NSMutableArray array];
    }
    return _dataSoureArray;
}
- (instancetype)initWithCellIndentifier:(NSString *)cellIndentifier configureCompleteHandler:(RAC_ConfigureCompleteHandler)rac_CompleteHandler
  tableView_DidSelectRowCompleteHandler:(void(^)(RACSignal *tableViewSingal))selectRowCompleteHandler{

    if (self = [super init]) {
        
        tempCellIndentifier = cellIndentifier;
        tempCompleteHandler = [rac_CompleteHandler copy];
        //监听数据源与信号源绑定
        dataSingal = RACObserve(self, dataSoureArray);
        //绑定didSelectRowAtIndexPath代理函数
        if (selectRowCompleteHandler) {
            
            RACSignal *selectRowsignal = [self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)];
            selectRowCompleteHandler(selectRowsignal);
        }
        
               
        
        
        
        
    }
    
    return self;
}

- (instancetype)initWithCellIndentifier:(NSString *)cellIndentifier configureCompleteHandler:(RAC_ConfigureCompleteHandler)rac_CompleteHandler tableView_DidSelectRowCompleteHandler:(void(^)(RACSignal *tableViewSingal))selectRowCompleteHandler deleteCellRowCompleteHandler:(void(^)(RACSignal *cellSingal))cellRowCompleteHandler{

    if (self = [super init]) {
        
        tempCellIndentifier = cellIndentifier;
        tempCompleteHandler = [rac_CompleteHandler copy];
        //监听数据源与信号源绑定
        dataSingal = RACObserve(self, dataSoureArray);
        //绑定didSelectRowAtIndexPath代理函数
        if (selectRowCompleteHandler) {
           
         RACSignal *selectRowsignal = [self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)];
            selectRowCompleteHandler(selectRowsignal);
        }
        
        //绑定tableView:commitEditingStyle:forRowAtIndexPath:代理函数
        
        if (cellRowCompleteHandler) {
            RACSignal *deleteRowsignal = [self rac_signalForSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:) fromProtocol:@protocol(UITableViewDataSource)];
            cellRowCompleteHandler(deleteRowsignal);
        }
        
        
        
        
        
    }
    
    return self;

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataSoureArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RACTableViewCell *rac_cell = [tableView dequeueReusableCellWithIdentifier:tempCellIndentifier forIndexPath:indexPath];
    
    if (tempCompleteHandler) {
        tempCompleteHandler(rac_cell,[dataSingal map:^id (NSArray *tempArray) {
            //信号源映射返回对应行的model
            return [self.dataSoureArray objectAtIndex:indexPath.row];
        }]);
    }
    
    
    return rac_cell;
    


}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

      return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
