//
//  HTScreenAdaptation.h
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTScreenAdaptation : NSObject

+ (CGRect)adapterRectByWidth:(CGRect)rect;

+ (CGFloat)adapterMultipleByWidth;

@end
