//
//  RACSingleViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/14.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACSingleViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>



@interface RACSingleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property(nonatomic,strong)RACSignal*single;
@end

@implementation RACSingleViewController
- (IBAction)test:(id)sender {
    
    //2,订阅信号
    //subscribeNext
    // 把nextBlock保存到订阅者里面
    // 只要订阅信号就会返回一个取消订阅信号的类
    
    @weakify(self);
    RACDisposable*disposable = [self.single subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.contentL.text = x;
        NSLog(@"订阅数据**接收到的数据:%@",x);
        
        
    }];
    [disposable dispose];
}
/*
 .核心：
 .核心：信号类
 .信号类的作用：只要有数据改变就会把数据包装成信号传递出去
 .只要有数据改变就会有信号发出
 .数据发出，并不是信号类发出，信号类不能发送数据
 .使用方法：
 .1创建信号
 .2订阅信号
 .实现思路：
 .当一个信号被订阅，创建订阅者，并把nextBlock保存到订阅者里面。
 .创建的时候会返回 [RACDynamicSignal createSignal:didSubscribe];
 .调用RACDynamicSignal的didSubscribe
 .发送信号[subscriber sendNext:value];
 .拿到订阅者的nextBlock调用 */
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1,创建信号
    self.single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3，发送信号
        [subscriber sendNext:@"发送信号***数据***"];
        // 4.取消信号，如果信号想要被取消，就必须返回一个RACDisposable
        // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
        //block什么时候调用：一旦一个信号被取消订阅就会调用
        //block作用：当信号被取消时用于清空一些资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
}
@end
