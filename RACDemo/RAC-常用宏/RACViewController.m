//
//  RACViewController.m
//  RACDemo
//
//  Created by yuchao on 2018/8/14.
//  Copyright © 2018年 zhz. All rights reserved.
//

#import "RACViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>



@interface RACViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *tes;

@end

@implementation RACViewController
- (IBAction)test:(id)sender {
}
- (IBAction)sliderClick:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self.contentL,text)= self.textV.rac_textSignal;
    [RACObserve(self.slider, value) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
     }];

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
