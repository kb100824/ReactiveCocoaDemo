//
//  ViewController.m
//  SXJFRAC_MVVMDEMO
//
//  Created by shanlin on 2017/9/8.
//  Copyright © 2017年 shanxingjinfu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  RACSignal *singal = [RACSignal createSignal:^RACDisposable * (id<RACSubscriber>   subscriber) {
//      
//      
//      
//      [subscriber sendNext:@"-->1"];
//      [subscriber sendNext:@"-->2"];
//      [subscriber sendNext:@"-->3"];
//      [subscriber sendNext:@"-->4"];
//      [subscriber sendCompleted];
//      
//      return [RACDisposable disposableWithBlock:^{
//          
//          
//      }];
//      
//  }];
//    
//    NSLog(@"signal was created");
//    
//    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
//       
//        [singal subscribeNext:^(id  _Nullable x) {
//            
//            NSLog(@"Subscriber 1 recveive: %@", x);
//        }];
//        
//    }];
//    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
//        
//        [singal subscribeNext:^(id  _Nullable x) {
//            
//            NSLog(@"Subscriber 2 recveive: %@", x);
//        }];
//        
//    }];
//    
//
    
    
    
    
    
//    RACMulticastConnection *connection  = [[RACSignal createSignal:^RACDisposable * (id<RACSubscriber>   subscriber) {
//        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
//            [subscriber sendNext:@1];
//        }];
//        
//        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
//            [subscriber sendNext:@2];
//        }];
//        
//        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
//            [subscriber sendNext:@3];
//        }];
//        
//        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
//            [subscriber sendCompleted];
//        }];
//        return nil;
//        
//    }] publish];
//    
//    [connection connect];
//    RACSignal *signal = connection.signal;
//    NSLog(@"Signal was created.");
//    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
//       
//        [signal subscribeNext:^(id   x) {
//            NSLog(@"Subscriber 1 recveive: %@", x);
//            
//        }];
//        
//    }];
//    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
//        
//        [signal subscribeNext:^(id   x) {
//            NSLog(@"Subscriber 2 recveive: %@", x);
//            
//        }];
//        
//    }];


    
    
//    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        [subscriber sendNext:@"test"];
//        [subscriber sendCompleted];
//         NSLog(@"Send Request");
//        return nil;
//        
//    }] publish];
//    
//    
//    [connection.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"product1: %@", x);
//    }];
//    [connection.signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"productId1: %@", x);
//    }];
//    [connection.signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"productId2: %@", x);
//    }];
//    [connection connect];
    
    
    
    //startWith  类似于sendNext 只不过startWith第一个发送
    
//    RACSignal *singal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        [subscriber sendNext:@"rac"];
//        [subscriber sendCompleted];
//        
//        return nil;
//    }] startWith:@"124"];
//    
//    [singal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    
    //timeout 超时
    
//   [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
//           
//            [subscriber sendNext:@"ractimeout"];
//            [subscriber sendCompleted];
//            
//        }];
//       
//        return nil;
//    }] timeout:2 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"x=%@",x);
//    }error:^(NSError *  error) {
//        NSLog(@"error=%@",error);
//        
//    }completed:^{
//        
//         NSLog(@"completed");
//    }];
//    
 
    
    //take-skip 筛选取和跳过
    
//    RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        [subscriber sendNext:@"rac1"];
//        [subscriber sendNext:@"rac2"];
//        [subscriber sendNext:@"rac3"];
//        [subscriber sendNext:@"rac4"];
//        [subscriber sendCompleted];
//        
//        
//        
//        return nil;
//    }];
//    
//    [[singal take:2] subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"x1=%@",x);
//    }];
//    
//    [[singal skip:3]subscribeNext:^(id  _Nullable x) {
//        
//         NSLog(@"x2=%@",x);
//    }];
//    
//    [[singal takeLast:2]subscribeNext:^(id  _Nullable x) {
//         NSLog(@"x3=%@",x);
//        
//    }];;
//    
    
    
    //repeat就是重复发送这条消息，当我们在后面添加了delay和take的时候，意思就是每隔1秒发送一次这条消息，发送3次后停止
    
//    [[[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        
//        [subscriber sendNext:@"rac"];
//        [subscriber sendCompleted];
//        
//        
//        return nil;
//    }] delay:1] repeat] take:3]subscribeNext:^(id  _Nullable x) {
//        
//         NSLog(@"x=%@",x);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    
     //merge合并A.B信号他们之间关系是独立的，如果A发送失败，B依然会执行。
     //concat方法链接A和B之后，意思就是当A执行完了之后才会执行B，他们之间是依赖的关系，如果A发送失败，B也不会执行。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          //  NSLog(@"a1=a");
            [subscriber sendNext:@"a"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          //  NSLog(@"a1=b");
            [subscriber sendNext:@"b"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    
    [[RACSignal merge:@[signalA,signalB]]subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"x1=%@",x);
    }];
    [[RACSignal concat:@[signalA,signalB]]subscribeNext:^(id  _Nullable x) {
        NSLog(@"x2=%@",x);
        
    }];
    
    [[RACSignal zip:@[signalA,signalB]]subscribeNext:^(id  _Nullable x) {
        NSLog(@"x3=%@",x);
        
    }];
  
 
   
    
}




@end
