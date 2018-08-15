//
//  RACBindViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/15.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACBindViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>


@interface RACBindViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property(nonatomic,strong)RACSubject*subj;
@property(nonatomic,strong)RACSignal*signal;

@end

@implementation RACBindViewController
- (IBAction)test:(id)sender {
    
    [self.subj sendNext:@"123"];
}
// bind（绑定）的使用思想和Hook的一样---> 都是拦截API从而可以对数据进行操作，，而影响返回数据。
// 发送信号的时候会来到30行的block。在这个block里我们可以对数据进行一些操作，那么35行打印的value和订阅绑定信号后的value就会变了。变成什么样随你喜欢喽。
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建信号
    self.subj = [RACSubject subject];
    
    //绑定信号：
    self.signal = [self.subj bind:^RACSignalBindBlock _Nonnull{
       //block调用时刻：只要绑定信号就会调用，不做什么事情；
        return ^RACSignal*(id value ,BOOL *stop){
            NSLog(@"接受到源信号的内容1：%@", value);
            // 一般在这个block中做事 ，发数据的时候会来到这个block。
            // 只要源信号（subject）发送数据，就会调用block
            // block作用：处理源信号内容
            // value:源信号发送的内容，
            value = @"3"; // 如果在这里把value的值改了，那么订阅绑定信号的值即44行的x就变了
            NSLog(@"接受到源信号的内容2：%@", value);
              return [RACReturnSignal return:value]; // 把返回的值包装成信号
        };
    }];
    //订阅信号
    [self.signal subscribeNext:^(id  _Nullable x) {
        
        
        self.contentL.text = x;

    }];
    // Do any additional setup after loading the view.
}


@end
