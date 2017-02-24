//
//  HTInputPasswordView.h
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComeparePasswordDelegate <NSObject>

- (void)compareResultWithPassword:(NSString *)password;

@end

@protocol ForgetPasswordDelegate <NSObject>

- (void)forgetPassword;

@end

@interface HTInputPasswordView : UIView

@property (nonatomic, weak) id<ComeparePasswordDelegate> comepareDelegate;
@property (nonatomic, weak) id<ForgetPasswordDelegate> forgetDelegate;

- (void)cleanPassword;
- (UITextField *)getInputTextField;

@end
