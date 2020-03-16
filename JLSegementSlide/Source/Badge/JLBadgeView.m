//
//  JLBadgeView.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLBadgeView.h"
#import <objc/runtime.h>
#import "NSString+JLBounding.h"

@implementation JLBadgeView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.superview) {
        return self.superview;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end

@implementation UIView (Badge)

- (JLBadge *)oneBadge {
    JLBadge *bage = nil;
    id obj = objc_getAssociatedObject(self, @selector(oneBadge));
    if ((JLBadge *)obj) {
        bage = (JLBadge *)obj;
    } else {
        bage = [[JLBadge alloc] initWithSuperView:self];
        objc_setAssociatedObject(self, @selector(oneBadge), bage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bage;
}

@end

@interface JLBadge()

@property (nonatomic, strong) JLBadgeView *badgeView;

@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation JLBadge

- (instancetype)initWithSuperView:(UIView *)superView {
    if (self = [super init]) {
        self.badgeView = [[JLBadgeView alloc] init];
        self.badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        self.badgeView.enabled = YES;
        self.badgeView.userInteractionEnabled = YES;
        self.badgeView.clipsToBounds = YES;
        self.badgeView.layer.masksToBounds = YES;
        self.badgeView.textAlignment = NSTextAlignmentCenter;
        self.badgeView.textColor = [UIColor whiteColor];
        self.badgeView.font =  [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        [superView addSubview:self.badgeView];
        
        self.height = 9;
        self.offset = CGPointZero;
        self.type = JLBadgeTypeNone;
        self.cornerRadiusForCustom = CGFLOAT_MIN;
    }
    return self;
}

#pragma mark - Setters
- (void)setFont:(UIFont *)font {
    _font = font;
    if (self.type == JLBadgeTypeCount) {
        self.badgeView.font = font;
    }
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    [self updateHeight];
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    [self remakeConstraints];
}

- (void)setType:(JLBadgeType)type {
    _type = type;
    switch (type) {
        case JLBadgeTypeNone:
        case JLBadgeTypePoint:
            self.badgeView.hidden = NO;
            self.badgeView.backgroundColor = [UIColor redColor];
            self.badgeView.numberOfLines = 1;
            self.badgeView.text = nil;
            self.badgeView.attributedText = nil;
            break;
        case JLBadgeTypeCount: {
            self.badgeView.hidden = self.countForBadge == 0;
            self.badgeView.backgroundColor = [UIColor redColor];
            self.badgeView.numberOfLines = 1;
            NSString *string = @"";
            if (self.countForBadge > 99) {
                string = @"99+";
            } else {
                string = @(self.countForBadge).stringValue;
            }
            self.badgeView.attributedText = nil;
            self.badgeView.text = string;
        }
            break;
        case JLBadgeTypeCustom: {
            self.badgeView.hidden = NO;
            self.badgeView.backgroundColor = [UIColor clearColor];
            self.badgeView.numberOfLines = 0;
            if (self.heightForCustom >= 0) {
                self.height = self.heightForCustom;
            }
            self.badgeView.text = nil;
            self.badgeView.attributedText = self.attributedStringForCustom;
        }
            break;
            
        default:
            break;
    }
    [self remakeConstraints];
}

#pragma mark - Private
- (void)remakeConstraints {
    if (!self.badgeView.superview) return;
    [self updateCenterXConstraint];
    [self updateCenterYConstraint];
    [self updateHeightConstraint];
    [self updateWidthConstraint];
    [self updateCornerRadius];
}

- (void)updateHeight {
    [self updateHeightConstraint];
    [self updateWidthConstraint];
    [self updateCornerRadius];
}

- (void)updateCenterXConstraint {
    if (!self.badgeView.superview) return;
    if (self.centerXConstraint) {
        self.centerXConstraint.constant = self.offset.x;
    } else {
        self.centerXConstraint = [self.badgeView.centerXAnchor constraintEqualToAnchor:self.badgeView.superview.centerXAnchor constant:self.offset.x];
        self.centerXConstraint.active = YES;
    }
}

- (void)updateCenterYConstraint {
    if (!self.badgeView.superview) return;
    if (self.centerYConstraint) {
        self.centerYConstraint.constant = self.offset.y;
    } else {
        self.centerYConstraint = [self.badgeView.centerYAnchor constraintEqualToAnchor:self.badgeView.superview.centerYAnchor constant:self.offset.y];
        self.centerYConstraint.active = YES;
    }
}

- (void)updateHeightConstraint {
    if (self.heightConstraint) {
        self.heightConstraint.constant = self.height;
    } else {
        self.heightConstraint = [self.badgeView.heightAnchor constraintEqualToConstant:self.height];
        self.heightConstraint.active = YES;
    }
}

- (void)updateWidthConstraint {
    CGFloat width;
    switch (self.type) {
        case JLBadgeTypeNone:
            width = 0;
            break;
        case JLBadgeTypePoint:
            width = self.height;
            break;
        case JLBadgeTypeCount:
            if (self.countForBadge > 0 && self.badgeView.text) {
                if (self.countForBadge >= 10) {
                    width = [self.badgeView.text boundingWidthWithFont:self.badgeView.font] + [@"0" boundingWidthWithFont:self.badgeView.font];
                } else {
                    width = self.height;
                }
            } else {
                width = 0;
            }
            break;
        case JLBadgeTypeCustom:
            width = CGFLOAT_MIN;
            break;
        default:
            break;
    }
    if (width != CGFLOAT_MIN) {
        if (self.widthConstraint) {
            self.widthConstraint.constant = width;
        } else {
            self.widthConstraint = [self.badgeView.widthAnchor constraintEqualToConstant:width];
            self.widthConstraint.active = YES;
        }
    } else {
        self.widthConstraint.active = NO;
        self.widthConstraint = nil;
    }
}

- (void)updateCornerRadius {
    switch (self.type) {
        case JLBadgeTypeNone:
            break;
        case JLBadgeTypePoint:
        case JLBadgeTypeCount:
            self.badgeView.layer.cornerRadius = self.height/2;
            break;
        case JLBadgeTypeCustom:
            if (self.cornerRadiusForCustom != CGFLOAT_MIN) {
                self.badgeView.layer.cornerRadius = self.cornerRadiusForCustom;
            } else {
                self.badgeView.layer.cornerRadius = self.height/2;
            }
            
        default:
            break;
    }
}

@end
