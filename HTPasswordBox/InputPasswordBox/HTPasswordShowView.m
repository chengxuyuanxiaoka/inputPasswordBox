//
//  HTPasswordShowView.m
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/3/3.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "HTPasswordShowView.h"
#import "HTInputPasswordView.h"

@interface HTInputPasswordView ()

@property (nonatomic,strong) HTInputPasswordView *inputPasswordBox;
@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation HTPasswordShowView {
    CGRect _passwordRect;
}

- (void)createInputPasswordBoxWithShowMode:(PasswordBoxShowMode)showMode {
    switch (showMode) {
        case BottomPop:{
            [self bottomPopInputPasswordBox];
            break;
        }
            
        case ScalePop:{
            [self scalePopInputPasswordBox];
            break;
        }
            
        default:
            break;
    }
}

- (void)bottomPopInputPasswordBox {
    _passwordRect = CGRectMake(0, 180, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-180);
    [[self.inputPasswordBox getInputTextField] becomeFirstResponder];
    [self addSubview:self.backgroundView];
    [self addSubview:self.inputPasswordBox];
    [self moveAnimationWithView:self.inputPasswordBox fromPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)) toPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2+90)];
}

- (void)scalePopInputPasswordBox {
    _passwordRect = CGRectMake(20, 100, CGRectGetWidth(self.bounds)-40, 180);
    [[self.inputPasswordBox getInputTextField] becomeFirstResponder];
    [self addSubview:self.backgroundView];
    [self addSubview:self.inputPasswordBox];
    self.inputPasswordBox.layer.masksToBounds = YES;
    self.inputPasswordBox.layer.cornerRadius = 3.0;
    [self scaleAnimationWithView:self.inputPasswordBox fromValue:0.2 toValue:1.0];
}

- (HTInputPasswordView *)inputPasswordBox {
    if (_inputPasswordBox == nil) {
        _inputPasswordBox = [[HTInputPasswordView alloc] initWithFrame:_passwordRect];
    }
    return _inputPasswordBox;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBottomPopInputPasswordBox)];
        [_backgroundView addGestureRecognizer:tapRecognizer];
    }
    return _backgroundView;
}

- (void)removeBottomPopInputPasswordBox {
    switch (self.showMode) {
        case BottomPop:{
            [self moveAnimationWithView:self.inputPasswordBox fromPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2+90) toPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds))];
            break;
        }
            
        case ScalePop:{
            [self scaleAnimationWithView:self.inputPasswordBox fromValue:1.0 toValue:0.2];
            break;
        }
        default:
            break;
    }
    [[self.inputPasswordBox getInputTextField] resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputPasswordBox cleanPassword];
        [self.inputPasswordBox removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    });
}

#pragma move animation
- (void)moveAnimationWithView:(UIView *)animationView fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 持续时间
    animation.duration = 0.2;
    animation.repeatCount = 1;
    //下面两句动画终了以后不返回初始状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // // 起始帧
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    // 终了帧
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    // 添加动画
    [animationView.layer addAnimation:animation forKey:@"move-layer"];
}

#pragma scale animation
- (void)scaleAnimationWithView:(UIView *)animationView fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画持续时间
    animation.duration = 0.2;
    // 重复次数
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 动画结束时执行逆动画
    animation.autoreverses = NO;
    // 开始时的倍率
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    // 结束时的倍率
    animation.toValue = [NSNumber numberWithFloat:toValue];
    // 添加动画
    [animationView.layer addAnimation:animation forKey:@"scale-layer"];
}

@end
