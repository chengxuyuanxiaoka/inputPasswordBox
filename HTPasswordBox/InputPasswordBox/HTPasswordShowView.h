//
//  HTPasswordShowView.h
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/3/3.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  BottomPop 密码框从底部弹出(类似于支付宝)
 *  ScalePop  密码框从中间弹出(类似于微信)
 */
typedef NS_ENUM(NSUInteger,PasswordBoxShowMode) {
    BottomPop = 1,
    ScalePop = 2
};

@class HTInputPasswordView;

@interface HTPasswordShowView : UIView

@property (nonatomic,strong) HTInputPasswordView *inputPasswordBox;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) PasswordBoxShowMode showMode;

- (void)createInputPasswordBoxWithShowMode:(PasswordBoxShowMode)showMode;
- (void)removeBottomPopInputPasswordBox;

@end
