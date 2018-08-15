//
//  RACMappingViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/15.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACMappingViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>


@interface RACMappingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end

@implementation RACMappingViewController
- (IBAction)test:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)map {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        // 返回的类型就是你需要映射的值
        return [NSString stringWithFormat:@"ws:%@", value]; //这里将源信号发送的“123” 前面拼接了ws：
    }];
    // 订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@"123"];
}







@end
