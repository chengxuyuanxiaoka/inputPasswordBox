//
//  ViewController.m
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"
#import "HTInputPasswordView.h"

typedef NS_ENUM(NSInteger,ComepareResult) {
    Success = 0,
    Failed = 1
};

@interface ViewController ()<ComeparePasswordDelegate,ForgetPasswordDelegate>

@property (nonatomic,strong) HTInputPasswordView *inputPasswordBox;
@property (nonatomic,strong) UIView *backgroundView;
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
    [[self.inputPasswordBox getInputTextField] becomeFirstResponder];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.inputPasswordBox];
}

- (HTInputPasswordView *)inputPasswordBox {
    if (_inputPasswordBox == nil) {
        _inputPasswordBox = [[HTInputPasswordView alloc] initWithFrame:CGRectMake(0, 180, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-180)];
        _inputPasswordBox.comepareDelegate = self;
        _inputPasswordBox.forgetDelegate = self;
    }
    return _inputPasswordBox;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
        [_backgroundView addGestureRecognizer:tapRecognizer];
    }
    return _backgroundView;
}

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
    [self removeInputPasswordBox];
}

- (void)removeInputPasswordBox {
    [self.inputPasswordBox cleanPassword];
    [self.inputPasswordBox removeFromSuperview];
    [self.backgroundView removeFromSuperview];
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
            [self.inputPasswordBox cleanPassword];
        }else{
            [self removeInputPasswordBox];
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
