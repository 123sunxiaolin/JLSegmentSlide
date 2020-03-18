//
//  JLSegementSlideViewController+Extention.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/17.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideViewController+Extention.h"

@implementation JLSegementSlideViewController (Extention)

- (CGFloat)topLayoutLength {
    CGFloat topLayoutLength;
    if (@available(iOS 11, *)) {
        topLayoutLength = self.view.safeAreaInsets.top;
    } else {
        topLayoutLength = self.topLayoutGuide.length;
    }
    return topLayoutLength;
}

- (CGFloat)bottomLayoutLength {
    CGFloat bottomLayoutLength;
    if (@available(iOS 11, *)) {
        bottomLayoutLength = self.view.safeAreaInsets.bottom;
    } else {
        bottomLayoutLength = self.bottomLayoutGuide.length;
    }
    return bottomLayoutLength;
}

@end
