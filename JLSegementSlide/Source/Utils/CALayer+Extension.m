//
//  CALayer+Extension.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

- (void)applySketchShadowWithColor:(UIColor *)color alpha:(float)alpha x:(CGFloat)x y:(CGFloat)y blur:(CGFloat)blur spread:(CGFloat)spread {
    self.shadowColor = color ? color.CGColor : [UIColor blackColor].CGColor;
    self.shadowOpacity = alpha;
    self.shadowOffset = CGSizeMake(x, y);
    self.shadowRadius = blur;
    if (spread == 0) {
        self.shadowPath = nil;
    } else {
        CGFloat dx = -spread;
        CGRect rect = CGRectMake(dx, dx, self.bounds.size.width, self.bounds.size.height);
        self.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    }
}

@end
