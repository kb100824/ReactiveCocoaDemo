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
        self.dataHelper.dataSoureArray = self.requestDataArray;
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










#4---->RACCommand模拟网络请求
```
@interface RACCommandRequest : NSObject
/**
 *  使用RACCommand来发送网络请求
 *   RACCommand中4个最重要的信号就是定义开头的那4个信号，executionSignals，executing，enabled，errors。需要注意的是，这4个信号基本都是（并不是完全是）在主线程上执行的
 *  @param urlString 接口url
 *  @param successCompleteHandler      请求成功回调
 *  @param failureCompleteHandler      请求失败回调
 */

+ (void)rac_CommandRequestWithURLString:(NSString *)urlString
                         rac_SuccessCompleteHandler:(void(^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void(^)(NSError *error))failureCompleteHandler;
                         
                         
                         
  @implementation RACCommandRequest

+ (void)rac_CommandRequestWithURLString:(NSString *)urlString rac_SuccessCompleteHandler:(void (^)(NSDictionary *))successCompleteHandler rac_FailureCompleteHandler:(void (^)(NSError *))failureCompleteHandler{

    RACCommand *raccommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * (id   input) {
        
        return [[RACSignal createSignal:^RACDisposable * (id<RACSubscriber>   subscriber) {
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSession *urlsession = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [urlsession dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
                if (error) {
                    [subscriber sendError:error];
                }else{
                    
                    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    [subscriber sendNext:resultDict];
                    [subscriber sendCompleted];
                    
                }
                
                
                
                
            }];
            [dataTask resume];
           
         return  [RACDisposable disposableWithBlock:^{
                
             [dataTask cancel];
            }]; //保证信号源主线程执行，不然导致ui无法刷新
        }] deliverOn:[RACScheduler mainThreadScheduler]];
    }];
    
    [raccommand.executionSignals subscribeNext:^(RACSignal *singal) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [singal subscribeNext:^(NSDictionary *resultDict) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            if (successCompleteHandler) {
                successCompleteHandler(resultDict);
            }
            
            
            
        }];
        
    }];
    
    [raccommand.errors subscribeNext:^(NSError *error) {
        
        if (failureCompleteHandler) {
            failureCompleteHandler(error);
        }


        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       
    }];
    
    [raccommand execute:@"test"];

}
                 
                         
 

```

#5---->RACMulticastConnection模拟网络请求
```
@interface RACMulticastConnectionRequest : NSObject
/**
 *  
 *  使用RACMulticastConnection来发送网络请求能解决信号每次订阅subscribeNext重复发起一次新的网络请求
 *  @param urlString 接口url
 *  @param successCompleteHandler      请求成功回调
 *  @param failureCompleteHandler      请求失败回调
 */

+ (void)rac_MulticastConnectionRequestWithURLString:(NSString *)urlString
                         rac_SuccessCompleteHandler:(void(^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void(^)(NSError *error))failureCompleteHandler;
                         
                         
                         
  @implementation RACMulticastConnectionRequest
+ (void)rac_MulticastConnectionRequestWithURLString:(NSString *)urlString rac_SuccessCompleteHandler:(void (^)(NSDictionary  *responseObject))successCompleteHandler rac_FailureCompleteHandler:(void (^)(NSError *))failureCompleteHandler{
   
    
      NSAssert(urlString,@"请设置好服务器接口url");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    RACMulticastConnection *connection = [[[RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *urlsession = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [urlsession dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
            if (error) {
                [subscriber sendError:error];
            }else{
              
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [subscriber sendNext:resultDict];
                [subscriber sendCompleted];
            
            }
            
            
            
            
        }];
        [dataTask resume];
        
        
        
        
        return [RACDisposable disposableWithBlock:^{
            
            [dataTask cancel];
            
        }]; //保证信号源主线程执行，不然导致ui无法刷新
    }] deliverOn:[RACScheduler mainThreadScheduler]]publish];
    
    
    [connection.signal  subscribeNext:^(NSDictionary *resultDict) {
        if (successCompleteHandler) {
            successCompleteHandler(resultDict);
        }
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [connection.signal subscribeError:^(NSError *  error) {
       
        if (failureCompleteHandler) {
            failureCompleteHandler(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
    
    
    [connection connect];
    
    


}
                     
 

```





#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/4.gif)



#6---->RACTimer倒计时



```
#import "RACTimerViewController.h"
#define kCountDownTimerSeconds 20
@interface RACTimerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@end

@implementation RACTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    // 验证码点击
    self.btnTimer.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self);
       
        return [self startTimerSingal:kCountDownTimerSeconds];
    }];



}

- (RACSignal *)startTimerSingal:(NSInteger)timerCountDown{
    
    @weakify(self);
    __block NSInteger countDown = timerCountDown;
    RACSignal *timerSingal = [[[RACSignal interval:1.0f
                                       onScheduler:[RACScheduler mainThreadScheduler]]
                               map:^id (NSDate *  date) {
                                   @strongify(self);
                                   
                                   NSString *tempTitle;
                                   BOOL countCompleted;
                                   
                                   if ((--countDown)<=0) {
                                       self.btnTimer.enabled = YES;
                                       tempTitle = [NSString stringWithFormat:@"%@",@"重新发送验证码"];
                                       countCompleted =  YES;
                                   }else{
                                       self.btnTimer.enabled = NO;
                                       tempTitle =[NSString stringWithFormat:@"%ld秒后重新获取验证码", countDown];
                                       countCompleted =  NO;
                                   }
                                   
                                   [self.btnTimer setTitle:tempTitle forState:UIControlStateNormal];
                                   self.lblTimer.text = tempTitle;
                                   return @(countCompleted);
                               }] takeUntilBlock:^BOOL(id  x) {
                                   
                                   return countDown<=0;
                                   
                               }];
    
    
    return timerSingal;
    
}




```






#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/5.gif)

















#7---->RACRefreshControl刷新控件

```
#import "RACRefreshControlViewController.h"

@interface RACRefreshControlViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *refreshScrollerview;

@end

@implementation RACRefreshControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIRefreshControl *refreshControl  = [[UIRefreshControl alloc]init];
    //设置刷新控件颜色
    RAC(refreshControl, tintColor) = [RACObserve(self.refreshScrollerview, contentOffset) map:^id (NSNumber   *value) {
        
        CGPoint piont = [value CGPointValue];
        return piont.y<0.0?[UIColor redColor]:[UIColor yellowColor];
        
    }];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIRefreshControl *refreshControl) {
        
        //模拟网络请求
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            
            [refreshControl endRefreshing];
            
        }];
        
    }];
    

    if(NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_9_x_Max){
    self.refreshScrollerview.refreshControl = refreshControl;
    }
    
    
    
    
}




```







#效果图:



![Image](https://github.com/KBvsMJ/ReactiveCocoaDemo/blob/master/SXJFRAC_MVVMDEMO/demo/6.gif)


