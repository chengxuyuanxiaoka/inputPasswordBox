//
//  HTInputPasswordView.m
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "HTInputPasswordView.h"
#import "HTPaySecurentView.h"
#import "HTScreenAdaptation.h"
#import "UIColor+HTRGB.h"

@interface HTInputPasswordView ()<
UITextFieldDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) HTPaySecurentView *paySecurentView;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@end

@implementation HTInputPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    CGFloat left = 0;
    CGFloat top = 0;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = 40*HTScreen;
    UIView *backGroudView = [[UIView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [self addSubview:backGroudView];
    CALayer *bottomLayer = [CALayer layer];
    [self addLineWithLayer:backGroudView.layer withPositionPoint:CGPointMake(width/2, height) withBounds:CGRectMake(0, height, width, 1) withSubLayer:bottomLayer withColor:[UIColor colorWithHTRGB:0xc9c9c9]];
    
    left = 30*HTScreen;
    width = width-2*left;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, width, height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15*HTScreen];
    self.titleLabel.textColor = [UIColor colorWithHTRGB:0x333333];
    self.titleLabel.text = @"输入支付密码";
    [backGroudView addSubview:self.titleLabel];
    
    CGSize arrowSize = [UIImage imageNamed:@"back"].size;
    left = 12*HTScreen;
    height = arrowSize.height;
    width = arrowSize.width;
    top = (40*HTScreen-height)/2;
    UIImageView *leftArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    leftArrowImageView.image = [UIImage imageNamed:@"back"];
    [backGroudView addSubview:leftArrowImageView];
    
    left = 24*HTScreen;
    top = top+40*HTScreen+21*HTScreen;
    width = CGRectGetWidth(self.bounds)-2*left;
    height = 50*HTScreen;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(left, top, width, height)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.returnKeyType = UIReturnKeyNext;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.textColor = [UIColor colorWithHTRGB:0x333333];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
    self.textField.tintColor = [UIColor clearColor];
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    self.paySecurentView = [[HTPaySecurentView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    self.paySecurentView.layer.borderWidth = 1.0;
    self.paySecurentView.layer.borderColor = [UIColor colorWithHTRGB:0xefefef].CGColor;
    [self addSubview:self.paySecurentView];
    
    left = CGRectGetWidth(self.bounds)-left-75*HTScreen;
    top = top+height+16*HTScreen;
    width = 75*HTScreen;
    height = 12*HTScreen;
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPasswordButton.frame = CGRectMake(left, top, width, height);
    [self.forgetPasswordButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:[UIColor colorWithHTRGB:0x4499ff] forState:UIControlStateNormal];
    self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:height];
    self.forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.forgetPasswordButton];
}

- (void)saveFirstPassword:(NSString *)password {
    [self.textField resignFirstResponder];
    if (self.comepareDelegate && [self.comepareDelegate respondsToSelector:@selector(compareResultWithPassword:)]) {
        [self.comepareDelegate compareResultWithPassword:password];
    }
}

- (void)forgetClick:(UIButton *)button {
    if (self.forgetDelegate && [self.forgetDelegate respondsToSelector:@selector(forgetPassword)]) {
        [self.forgetDelegate forgetPassword];
    }
}

- (void)cleanPassword {
    self.textField.text = nil;
    [self.paySecurentView setupSubviewsWithPassword:@""];
}

#pragma TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *addMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    if ([string isEqualToString:@""]) {
        if (addMutableStr.length != 0) {
            NSRange deleteRange = NSMakeRange(addMutableStr.length-1, 1);
            [addMutableStr deleteCharactersInRange:deleteRange];
        }
    }else{
        [addMutableStr appendString:string];
    }
    
    [self.paySecurentView setupSubviewsWithPassword:[addMutableStr copy]];
    if (addMutableStr.length == 6) {
        [self saveFirstPassword:addMutableStr];
    }
    return YES;
}

- (void)addLineWithLayer:(CALayer *)superLayer withPositionPoint:(CGPoint)point withBounds:(CGRect)rect withSubLayer:(CALayer *)subLayer withColor:(UIColor *)color {
    subLayer.bounds = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    subLayer.position = CGPointMake(point.x, point.y);
    subLayer.backgroundColor = color.CGColor;
    [superLayer addSublayer:subLayer];
}

- (UITextField *)getInputTextField {
    return self.textField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
