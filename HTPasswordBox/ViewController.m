//
//  ViewController.m
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"
#import "HTPasswordShowView.h"
#import "HTInputPasswordView.h"

typedef NS_ENUM(NSInteger,ComepareResult) {
    Success = 0,
    Failed = 1
};

@interface ViewController ()<ComeparePasswordDelegate,ForgetPasswordDelegate>

@property (nonatomic, strong) HTPasswordShowView *showView;
@property (nonatomic,assign) ComepareResult comepareResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *inputPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inputPasswordButton.frame = CGRectMake(50, 200, CGRectGetWidth(self.view.bounds)-100, 30);
    [inputPasswordButton setTitle:@"输入密码" forState:UIControlStateNormal];
    [inputPasswordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [inputPasswordButton addTarget:self action:@selector(selectedInputPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputPasswordButton];
}

- (void)selectedInputPassword:(UIButton *)btn {
    [self.view addSubview:self.showView];
    self.showView.showMode = ScalePop;
    [self.showView createInputPasswordBoxWithShowMode:ScalePop];
    self.showView.inputPasswordBox.comepareDelegate = self;
    self.showView.inputPasswordBox.forgetDelegate = self;
}

- (HTPasswordShowView *)showView {
    if (_showView == nil) {
        _showView = [[HTPasswordShowView alloc] initWithFrame:self.view.bounds];
    }
    return _showView;
}

#pragma InputPasswordDelegate
- (void)compareResultWithPassword:(NSString *)password {
    NSLog(@"密码输入完毕，比对密码");
    self.comepareResult = Success;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (self.comepareResult) {
            case Success:{
                [self alertWithMessage:@"输入密码成功" AndResult:@"确定"];
                break;
            }
                
            case Failed:{
                [self alertWithMessage:@"输入密码错误" AndResult:@"重试"];
                break;
            }
            default:
                break;
        }
    });
}

#pragma ForgetPasswordDelegate
- (void)forgetPassword {
    NSLog(@"忘记密码");
}

- (void)alertWithMessage:(NSString *)msg AndResult:(NSString *)result {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resultAction = [UIAlertAction actionWithTitle:result style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.comepareResult == Failed) {
            [[self.showView.inputPasswordBox getInputTextField] becomeFirstResponder];
            [self.showView.inputPasswordBox cleanPassword];
        }else{
            [self.showView removeBottomPopInputPasswordBox];
        }
    }];
    [alertController addAction:resultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
