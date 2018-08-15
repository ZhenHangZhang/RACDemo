//
//  RACMulticastConnectionViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/14.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACMulticastConnectionViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>



@interface RACMulticastConnectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property(nonatomic,strong)RACSignal*single;


@property(nonatomic,assign)NSInteger count1;
@property(nonatomic,assign)NSInteger count2;

@end

@implementation RACMulticastConnectionViewController
- (IBAction)test:(id)sender {
    RACMulticastConnection *connection = [self.single publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    //3. 连接。只有连接了才会把信号源变为热信号
    [connection connect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    // 普通写法, 这样的缺点是：没订阅一次信号就得重新创建并发送请求，这样很不友好
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求---比如afn
        @strongify(self);
        self.count1++;
        NSLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:[NSString stringWithFormat:@"connection-消息请求%ld次",(long)self.count1]];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    
    
    // 比较好的做法。 使用RACMulticastConnection，无论有多少个订阅者，无论订阅多少次，我只发送一个。
    // 1.发送请求，用一个信号内包装，不管有多少个订阅者，只想发一次请求
    self.single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送请求啦");
        @strongify(self);
        self.count2++;
        // 发送信号
        [subscriber sendNext:[NSString stringWithFormat:@"connection-消息只需要发送一次请求即可%ld",(long)self.count2]];
        return nil;
    }];
    //2. 创建连接类
    
}
/**
 2018-08-14 16:39:43.814304+0800 RACDemo[2596:73190] 发送请求啦
 2018-08-14 16:39:43.814576+0800 RACDemo[2596:73190] connection-消息请求1次
 2018-08-14 16:39:43.814811+0800 RACDemo[2596:73190] 发送请求啦
 2018-08-14 16:39:43.814991+0800 RACDemo[2596:73190] connection-消息请求2次
 2018-08-14 16:39:43.816049+0800 RACDemo[2596:73190] 发送请求啦
 2018-08-14 16:39:43.816599+0800 RACDemo[2596:73190] connection-消息请求3次
 ************************************************************************************
 2018-08-14 16:39:49.783683+0800 RACDemo[2596:73190] 发送请求啦
 2018-08-14 16:39:49.783996+0800 RACDemo[2596:73190] connection-消息只需要发送一次请求即可1
 2018-08-14 16:39:49.784373+0800 RACDemo[2596:73190] connection-消息只需要发送一次请求即可1
 2018-08-14 16:39:49.784623+0800 RACDemo[2596:73190] connection-消息只需要发送一次请求即可1
 */



@end
