//
//  UIView+JLConstraint.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "UIView+JLConstraint.h"
#import <objc/runtime.h>

@implementation UIView (JLConstraint)

- (NSLayoutConstraint *)topConstraint {
    id value = objc_getAssociatedObject(self, @selector(topConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint {
    self.topConstraint.active = NO;
    if (topConstraint) {
        topConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(topConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomConstraint {
    id value = objc_getAssociatedObject(self, @selector(bottomConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setBottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    self.bottomConstraint.active = NO;
    if (bottomConstraint) {
        bottomConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(bottomConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingConstraint {
    id value = objc_getAssociatedObject(self, @selector(leadingConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setLeadingConstraint:(NSLayoutConstraint *)leadingConstraint {
    self.leadingConstraint.active = NO;
    if (leadingConstraint) {
        leadingConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(leadingConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingConstraint {
    id value = objc_getAssociatedObject(self, @selector(trailingConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setTrailingConstraint:(NSLayoutConstraint *)trailingConstraint {
    self.trailingConstraint.active = NO;
    if (trailingConstraint) {
        trailingConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(trailingConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthConstraint {
    id value = objc_getAssociatedObject(self, @selector(widthConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    self.widthConstraint.active = NO;
    if (widthConstraint) {
        widthConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(widthConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint {
    id value = objc_getAssociatedObject(self, @selector(heightConstraint));
    if ([value isKindOfClass:[NSLayoutConstraint class]]) {
        return value;
    }
    return nil;
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    self.heightConstraint.active = NO;
    if (heightConstraint) {
        heightConstraint.active = YES;
    }
    objc_setAssociatedObject(self, @selector(heightConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)constraintToSuperview {
    if (!self.superview) return;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.topConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor];
    self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor];
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor];
    self.trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor];
}

- (void)removeAllConstraints {
    self.topConstraint = nil;
    self.bottomConstraint = nil;
    self.leadingConstraint = nil;
    self.trailingConstraint = nil;
    self.widthConstraint = nil;
    self.heightConstraint = nil;
}

@end
