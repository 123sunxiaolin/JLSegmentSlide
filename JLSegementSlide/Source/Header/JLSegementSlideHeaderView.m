//
//  JLSegementSlideHeaderView.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideHeaderView.h"
#import "JLSegementSlideContentView.h"
#import "UIView+JLConstraint.h"

@interface JLSegementSlideHeaderView()

@property (nonatomic, weak) JLSegementSlideContentView *segementSlideContentView;
@property (nonatomic, weak) UIView *lastHeaderView;

@end
@implementation JLSegementSlideHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
}

- (void)configueWithHeaderView:(UIView *)headerView segementSlideContentView:(JLSegementSlideContentView *)segementSlideContentView {
    if (headerView == self.lastHeaderView) return;
    if (self.lastHeaderView) {
        [self.lastHeaderView removeAllConstraints];
        [self.lastHeaderView removeFromSuperview];
    }
    if (!headerView) return;
    self.segementSlideContentView = segementSlideContentView;
    [self addSubview:headerView];
    [headerView constraintToSuperview];
    self.lastHeaderView = headerView;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!self.segementSlideContentView) {
        return view;
    }
    
    id <JLSegementSlideContentScrollViewDelegate> segementSlideContentScrollViewDelegate = [self.segementSlideContentView dequeueReusableViewControllerAtIndex:self.segementSlideContentView.selectedIndex];
    BOOL canGo = (self.segementSlideContentView.selectedIndex != NSIntegerMin) && segementSlideContentScrollViewDelegate;
    if (!canGo) {
        return view;
    }
    
    if ([view isKindOfClass:[UIControl class]]) {
        return view;
    }
    
    if (view.gestureRecognizers.count > 0) {
        return view;
    }
    return segementSlideContentScrollViewDelegate.scrollView;
}

@end
