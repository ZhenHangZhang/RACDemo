//
//  RACSubjectViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/14.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACSubjectViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>



@interface RACSubjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property(nonatomic,strong)RACSubject*subject;


@end

@implementation RACSubjectViewController
- (IBAction)test:(id)sender {
    //发送信号
    [self.subject sendNext:@"发射数据"];
}

/**
 注意 RACSubject和RACReplaySubject的区别 RACSubject必须要先订阅信号之后才能发送信号， 而RACReplaySubject可以先发送信号后订阅. RACSubject 代码中体现为：先走TwoViewController的sendNext，后走ViewController的subscribeNext订阅 RACReplaySubject 代码中体现为：先走ViewController的subscribeNext订阅，后走TwoViewController的sendNext 可按实际情况各取所需。
 
 RACSubject 在使用中我们可以完全代替代理进行回调传值。
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建信号
    self.subject = [RACSubject subject];
    //订阅信号
    @weakify(self);
    [self.subject subscribeNext:^(id  _Nullable x) {
        // block:当有数据发出的时候就会调用
        // block:处理数据
        @strongify(self);
        self.contentL.text = x;
        NSLog(@"%@",x);
    }];
}


@end
