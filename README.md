# Reactivecocoa+MVVM  Demo例子练习




#1---->RACTableViewController控制器源码:
```


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
        
        [tableViewSingal subscribeNext:^(RACTuple *tuple) {
            //因为是绑定didSelectRowAtIndexPath代理函数只有两个参数所以这只需要first和second
            UITableView *tableView = tuple.first;
            NSIndexPath *indexpath = tuple.second;
            NSLog(@"selectRow=%ld\n indexpath=%@",tableView.indexPathForSelectedRow.row,indexpath);
            
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





```



#RACModel模型源码:
```
@interface RACModel : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detail;
@end
```


#RACViewModel源码:
```
@interface RACViewModel : NSObject
//模拟请求加载数据
+ (void)requestLoadDataCompleteHandler:(void(^)(NSArray *tempArray))dataCompleteHandler;
//模拟请求加载更多数据
+ (void)requestLoadMoreDataCompleteHandler:(void(^)(NSArray *tempArray))dataCompleteHandler;
@end

+ (void)requestLoadDataCompleteHandler:(void (^)(NSArray *))dataCompleteHandler{

    
    

   
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray removeAllObjects];
    for (NSInteger i =0; i<10; i++) {
        
        RACModel *model = [RACModel new];
        model.title = [NSString stringWithFormat:@"RAC_MVVM_Title_%ld",i];
        model.detail = [NSString stringWithFormat:@"RAC_MVVM_Detail_%ld",i];
        
        [tempArray addObject:model];
        
        
    }
    
    if (dataCompleteHandler) {
        dataCompleteHandler([tempArray copy]);
    }
    
    

}
+ (void)requestLoadMoreDataCompleteHandler:(void(^)(NSArray *tempArray))dataCompleteHandler{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray removeAllObjects];
        for (NSInteger i =11; i<100; i++) {
            
            RACModel *model = [RACModel new];
            model.title = [NSString stringWithFormat:@"RAC_MVVM_Title_%ld",i];
            model.detail = [NSString stringWithFormat:@"RAC_MVVM_Detail_%ld",i];
            
            [tempArray addObject:model];
            
            
        }
        
        if (dataCompleteHandler) {
            dataCompleteHandler([tempArray copy]);
        }
        

        
        
    });

}
```

#RACDataHelper源码：
```
@class RACTableViewCell;
//返回cell,以及数据信号源
 typedef void(^RAC_ConfigureCompleteHandler)(RACTableViewCell *racCell,RACSignal *modelSingal);

@interface RACDataHelper : NSObject<UITableViewDelegate,UITableViewDataSource>

//接收模拟网络请求回来的数据
@property(nonatomic,copy) NSArray *dataSoureArray;

/**
 **  
 ** @param cellIndentifier cell复用标识符
 ** @rac_CompleteHandler  block回调
 */
- (instancetype)initWithCellIndentifier:(NSString *)cellIndentifier configureCompleteHandler:(RAC_ConfigureCompleteHandler)rac_CompleteHandler
  tableView_DidSelectRowCompleteHandler:(void(^)(RACSignal *tableViewSingal))selectRowCompleteHandler;

@end

@interface RACDataHelper ()
{
    RAC_ConfigureCompleteHandler tempCompleteHandler;
    RACSignal *dataSingal;
    NSString *tempCellIndentifier;
}




@end
@implementation RACDataHelper


- (instancetype)initWithCellIndentifier:(NSString *)cellIndentifier configureCompleteHandler:(RAC_ConfigureCompleteHandler)rac_CompleteHandler tableView_DidSelectRowCompleteHandler:(void(^)(RACSignal *tableViewSingal))selectRowCompleteHandler{

    if (self = [super init]) {
        
        tempCellIndentifier = cellIndentifier;
        tempCompleteHandler = [rac_CompleteHandler copy];
        //监听数据源与信号源绑定
        dataSingal = RACObserve(self, dataSoureArray);
        
        if (selectRowCompleteHandler) {
           
         RACSignal *signal = [self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)];
            selectRowCompleteHandler(signal);
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
        tempCompleteHandler(rac_cell,[[dataSingal takeUntil:rac_cell.rac_prepareForReuseSignal] map:^id (NSArray *tempArray) {
            //信号源映射返回对应行的model
            return [self.dataSoureArray objectAtIndex:indexPath.row];
        }]);

    }
    
    
    return rac_cell;
    


}
```

#RACTableViewCell源码:
```
@interface RACTableViewCell : UITableViewCell
/**
 ** @param modelSingal 信号源订阅遍历对应的model刷新UI控件
 */
- (void)configureBindCellData:(RACSignal *)modelSingal;
@end

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
    [modelSingal subscribeNext:^(RACModel *rac_Model) {
        @strongify(self);
        
        self.lbl_title.text = rac_Model.title;
        self.lbl_detail.text = rac_Model.detail;
        
        
        
        
    }];
    
    

}
```











#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/1.gif)










#2---->RACCommand模拟登录demo

##LoginViewModel核心源码如下:
```
#import <Foundation/Foundation.h>
#import "LoginModel.h"
@interface LoginViewModel : NSObject

@property(nonatomic,strong) LoginModel *userModel;

@property(nonatomic,strong,readonly) RACCommand *loginCommand;



#import "LoginViewModel.h"
#import "RequestNetWorkHelper.h"

@interface LoginViewModel ()

@end
@implementation LoginViewModel


- (instancetype)init{

    if (self = [super init]) {
        
        
        _userModel = [LoginModel new];
        
        RACSignal *userNameLengthSingal = [RACObserve(self, userModel.userName) map:^id (NSString *userName) {
            
            return userName.length>3?@(YES):@(NO);
            
        }];
        
        RACSignal *userPwdLengthSingal = [RACObserve(self, userModel.userPassWord) map:^id (NSString *userPwd) {
            
            return userPwd.length>3?@(YES):@(NO);
        }];
        
         RACSignal *loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSingal,userPwdLengthSingal] reduce:^id(NSNumber *userName, NSNumber *password){
             return @([userName boolValue] && [password boolValue]);
            
        }];
        
        @weakify(self);
        _loginCommand = [[RACCommand alloc]initWithEnabled:loginBtnEnable signalBlock:^RACSignal * _Nonnull(id   input) {
            @strongify(self);
            return [RequestNetWorkHelper loginInServiceUserName:self.userModel.userName password:self.userModel.userPassWord];
        }];
        
    }
    return self;
    
    
    
}





@end





```



#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/2.gif)









#3---->RAC替代Delegate传值
##部分源码如下:

```
 @weakify(self);
    [[self rac_signalForSelector:@selector(testRACSubjectDelegate:) fromProtocol:@protocol(RACSubjectDelegate)]subscribeNext:^(RACTuple * tuple) {
        @strongify(self);
        UIView *tempView = self.view;
        
        tempView.backgroundColor = [UIColor yellowColor];
        
        
        NSLog(@"tuple=%@",tuple);
    }];



@class RACSubjectDelegate;
@protocol RACSubjectDelegate <NSObject>
@optional;
- (void)testRACSubjectDelegate:(UIView*)currentView;

@end

@interface RACSecondViewController : UIViewController
//用于传值
@property(nonatomic,strong)RACSubject *delegateSubject;

@property(nonatomic,weak)id<RACSubjectDelegate>racDelegate;

@end
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




```




#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/3.gif)


