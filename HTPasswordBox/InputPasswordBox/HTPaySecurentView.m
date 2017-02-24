//
//  HTPaySecurentView.h
//  HTPasswordBox
//
//  Created by 一米阳光 on 17/2/24.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "HTPaySecurentView.h"
#import "UIColor+HTRGB.h"
#import "HTScreenAdaptation.h"

@interface HTPaySecurentView ()

@property (nonatomic, strong) NSString *passwordStr;

@end

@implementation HTPaySecurentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSubviewsWithPassword:(NSString *)password {
    self.passwordStr = password;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = (self.bounds.size.width-5)/6;
    CGContextRef lineContext = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(lineContext,kCGLineCapSquare);
    CGContextSetLineWidth(lineContext,1.0);
    CGContextSetRGBStrokeColor(lineContext,239/255.0, 239/255.0,239/255.0, 1);
    CGContextBeginPath(lineContext);
    for (int i = 0; i < 6; i++) {
        CGContextMoveToPoint(lineContext,width+(width+1)*i, 0);
        CGContextAddLineToPoint(lineContext,width+(width+1)*i, CGRectGetHeight(self.bounds));
    }
    CGContextStrokePath(lineContext);
    CGContextRef circleContext = UIGraphicsGetCurrentContext();
    CGFloat squareWidth = (CGRectGetWidth(self.bounds)-5)/6+1;
    CGFloat circleX = (CGRectGetWidth(self.bounds)-5)/6/2;
    CGFloat circleY = CGRectGetHeight(self.bounds)/2;
    CGContextSetFillColorWithColor(circleContext, [UIColor blackColor].CGColor);
    for (int i = 0; i < self.passwordStr.length; i++) {
        CGContextAddArc(circleContext, circleX+squareWidth*i, circleY, 7.5, 0, 2*M_PI, 0);
        CGContextDrawPath(circleContext, kCGPathFill);
    }
    CGContextStrokePath(circleContext);
}

@end
