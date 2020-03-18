//
//  CALayer+Extension.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Extension)

- (void)applySketchShadowWithColor:(UIColor *)color
                             alpha:(float)alpha
                                 x:(CGFloat)x
                                 y:(CGFloat)y
                              blur:(CGFloat)blur
                            spread:(CGFloat)spread;

@end

NS_ASSUME_NONNULL_END
