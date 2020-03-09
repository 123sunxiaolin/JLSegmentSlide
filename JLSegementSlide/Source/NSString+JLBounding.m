//
//  NSString+JLBounding.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "NSString+JLBounding.h"

@implementation NSString (JLBounding)

- (CGFloat)boundingWidthWithFont:(UIFont *)font {
    CGSize size = CGSizeMake(CGFLOAT_MAX, font.lineHeight);
    CGRect preferredRect = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: font} context:nil];
    return ceil(preferredRect.size.width);
}

@end
