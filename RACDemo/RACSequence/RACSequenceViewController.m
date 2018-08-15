//
//  RACSequenceViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/14.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACSequenceViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACSequenceModel.h"





@interface RACSequenceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property(nonatomic,strong)NSMutableArray*dataarr;

@end

@implementation RACSequenceViewController
- (IBAction)test:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"*****%@",[NSThread mainThread]);
    [self.dataarr removeAllObjects];
    
    for (NSDictionary*dic in dictArr) {
        RACSequenceModel*model = [RACSequenceModel new];
        model.name = dic[@"name"];
        model.icom = dic[@"icon"];
        [self.dataarr addObject:model];
    }
    //使用场景---： 可以快速高效的遍历数组和字典。
    @weakify(self);
    [self.dataarr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"%@",x);
        //异步遍历
        
        /**
         2018-08-14 15:50:46.186494+0800 RACDemo[1890:45315] ***主线程**<NSThread: 0x60000007d540>{number = 1, name = main}
         2018-08-14 15:50:46.187972+0800 RACDemo[1890:45481] <RACSequenceModel: 0x604000236860>
         2018-08-14 15:50:46.188438+0800 RACDemo[1890:45481] <NSThread: 0x600000475480>{number = 3, name = (null)}
         2018-08-14 15:50:46.188847+0800 RACDemo[1890:45481] <RACSequenceModel: 0x604000230cc0>
         2018-08-14 15:50:46.189458+0800 RACDemo[1890:45481] <NSThread: 0x600000475480>{number = 3, name = (null)}
         */
        NSLog(@"%@",[NSThread currentThread]);
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            [self.contentL setText: [NSString stringWithFormat:@"%lu",(unsigned long)[self.dataarr indexOfObject:x]]];

        });
        
    } error:^(NSError * _Nullable error) {
        NSLog(@"===error===");
        
    } completed:^{
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
self.contentL.text = @"遍历结束";
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataarr = [NSMutableArray array];
    NSDictionary *dict = @{@"key":@1, @"key2":@2};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
        NSString *key = x[0];
        NSString *value = x[1];
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
//        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@ %@", key, value);
    } error:^(NSError *error) {
        NSLog(@"===error");
    } completed:^{
        NSLog(@"-----ok---完毕");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
