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


    
    
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"test"];
        [subscriber sendCompleted];
         NSLog(@"Send Request");
        return nil;
        
    }] publish];
    
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"product1: %@", x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"productId1: %@", x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"productId2: %@", x);
    }];
    [connection connect];
    
}




@end
