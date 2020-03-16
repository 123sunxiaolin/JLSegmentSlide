//
//  JLSegementSlideSwitcherView.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideSwitcherView.h"
#import "UIView+JLConstraint.h"
#import "NSString+JLBounding.h"
#import "JLBadgeView.h"

@interface JLSegementSlideSwitcherView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, assign) NSInteger initSelectedIndex;
@property (nonatomic, strong) JLSegmentSlideSwitcherSharedConfig *innerConfig;
@property (nonatomic, copy, readonly) NSArray<UIGestureRecognizer *> *gestureRecognizersInScrollView;

@end

@implementation JLSegementSlideSwitcherView

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

- (CGSize)intrinsicContentSize {
    return self.scrollView.contentSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutTitleButtons];
    [self reloadBadges];
    [self recoverInitSelectedIndex];
    [self updateSelectedIndex];
}

- (void)reloadData {
    for (UIButton *titleButton in self.titleButtons) {
        [titleButton removeFromSuperview];
        titleButton.frame = CGRectZero;
    }
    [self.titleButtons removeAllObjects];
    [self.indicatorView removeFromSuperview];
    self.indicatorView.frame = CGRectZero;
    self.scrollView.scrollEnabled = self.innerConfig.type == JLSwitcherTypeSegment;
    self.innerConfig = self.config;
    NSArray *titles = [self.delegate titlesInSegementSlideSwitcherView];
    if (!titles.count) return;
    for (NSInteger index = 0; index < titles.count; index ++) {
        @autoreleasepool {
            NSString *title = titles[index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.clipsToBounds = NO;
            button.titleLabel.font = self.innerConfig.normalTitleFont;
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:title forState:UIControlStateNormal];
            button.tag = index;
            [button setTitleColor:self.innerConfig.normalTitleColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            [self.titleButtons addObject:button];
        }
    }
    
    if (!self.titleButtons.count) return;
    [self.scrollView addSubview:self.indicatorView];
    self.indicatorView.layer.masksToBounds = YES;
    self.indicatorView.layer.cornerRadius = self.innerConfig.indicatorHeight/2;
    self.indicatorView.backgroundColor = self.innerConfig.indicatorColor;
    [self layoutTitleButtons];
    [self reloadBadges];
    [self updateSelectedIndex];
}

- (void)reloadBadges {
    for (NSInteger i = 0; i < self.titleButtons.count; i ++) {
        @autoreleasepool {
            UIButton *titleButton = self.titleButtons[i];
            JLBadgeType type = JLBadgeTypeNone;
            if (![self.delegate respondsToSelector:@selector(segementSlideSwitcherView:showBadgeAtIndex:)]) {
                titleButton.oneBadge.type = JLBadgeTypeNone;
                continue;
            }
            type = [self.delegate segementSlideSwitcherView:self showBadgeAtIndex:i];
            titleButton.oneBadge.type = type;
            if (JLBadgeTypeNone == type) continue;
            
            NSString *titleLabelText = titleButton.titleLabel.text; // ?? ""
            CGFloat width = 0;
            if (self.selectedIndex == i) {
                width = [titleLabelText boundingWidthWithFont:self.innerConfig.selectedTitleFont];
            } else {
                width = [titleLabelText boundingWidthWithFont:self.innerConfig.normalTitleFont];
            }
            CGFloat height = titleButton.titleLabel.font.lineHeight; // ?? titleButton.bounds.height
            switch (type) {
                case JLBadgeTypeNone:
                    break;
                case JLBadgeTypePoint:
                    titleButton.oneBadge.height = self.innerConfig.badgeHeightForPointType;
                    titleButton.oneBadge.offset = CGPointMake(width/2+titleButton.oneBadge.height/2, -height/2);
                    break;
                case JLBadgeTypeCount:
                    titleButton.oneBadge.font = self.innerConfig.badgeFontForCountType;
                    titleButton.oneBadge.height = self.innerConfig.badgeHeightForCountType;
                    titleButton.oneBadge.offset = CGPointMake(width/2 + titleButton.oneBadge.height/2, -height/2);
                    break;
                    case JLBadgeTypeCustom:
                    titleButton.oneBadge.height = self.innerConfig.badgeHeightForCustomType;
                    titleButton.oneBadge.offset = CGPointMake(width/2 + titleButton.oneBadge.height/2, -height/2);
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)selectSwitcherAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self updateSelectedButtonAtIndex:index animated:animated];
}

#pragma mark - Private
- (void)setup {
    [self initialize];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    [self.scrollView constraintToSuperview];
}

- (void)initialize {
    self.innerConfig = [JLSegmentSlideSwitcherSharedConfig sharedConfig];
    self.config = [JLSegmentSlideSwitcherSharedConfig sharedConfig];
}

- (void)layoutTitleButtons {
    if (CGRectEqualToRect(self.scrollView.frame, CGRectZero)) return;
    if (!self.titleButtons.count) {
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        return;
    }
    CGFloat offsetX = self.innerConfig.horizontalMargin;
    for (UIButton *titleButton in self.titleButtons) {
        CGFloat buttonWidth = 0;
        switch (self.innerConfig.type) {
            case JLSwitcherTypeTab:
                buttonWidth = (self.bounds.size.width - self.innerConfig.horizontalMargin * 2)/self.titleButtons.count;
                break;
            case JLSwitcherTypeSegment: {
                NSString *title = [titleButton titleForState:UIControlStateNormal];
                title = title ? title : @"";
                CGFloat normalButtonWidth = [title boundingWidthWithFont:self.innerConfig.normalTitleFont];
                CGFloat selectedButtonWidth = [title boundingWidthWithFont:self.innerConfig.selectedTitleFont];
                buttonWidth = selectedButtonWidth > normalButtonWidth ? selectedButtonWidth : normalButtonWidth;
            }
                break;
            default:
                break;
        }
        titleButton.frame = CGRectMake(offsetX, 0, buttonWidth, self.scrollView.frame.size.height);
        switch (self.innerConfig.type) {
            case JLSwitcherTypeTab:
                offsetX += buttonWidth;
                break;
            case JLSwitcherTypeSegment:
                offsetX += buttonWidth + self.innerConfig.horizontalSpace;
                break;
                
            default:
                break;
        }
    }
    
    switch (self.innerConfig.type) {
    case JLSwitcherTypeTab:
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        break;
    case JLSwitcherTypeSegment:
            self.scrollView.contentSize = CGSizeMake(offsetX - self.innerConfig.horizontalSpace + self.innerConfig.horizontalMargin, self.bounds.size.height);
        break;
        
    default:
        break;
    }
}

- (void)recoverInitSelectedIndex {
    if (self.initSelectedIndex == NSIntegerMin) return;
    self.initSelectedIndex = NSIntegerMin;
    [self updateSelectedButtonAtIndex:self.initSelectedIndex animated:NO];
}

- (void)updateSelectedIndex {
    if (self.selectedIndex == NSIntegerMin) return;
     [self updateSelectedButtonAtIndex:self.selectedIndex animated:NO];
}

- (void)updateSelectedButtonAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (CGRectEqualToRect(self.scrollView.frame, CGRectZero)) {
        self.initSelectedIndex = NSIntegerMin;
        return;
    }
    
    if (!self.titleButtons.count) return;
    if (self.selectedIndex >= 0 && self.selectedIndex < self.titleButtons.count) {
        UIButton *titleButton = self.titleButtons[self.selectedIndex];
        [titleButton setTitleColor:self.innerConfig.normalTitleColor forState:UIControlStateNormal];
        titleButton.titleLabel.font = self.innerConfig.normalTitleFont;
    }
    
    if (!(index >= 0 && index < self.titleButtons.count)) return;
    UIButton *titleButton = self.titleButtons[index];
    [titleButton setTitleColor:self.innerConfig.selectedTitleColor forState:UIControlStateNormal];
    titleButton.titleLabel.font = self.innerConfig.selectedTitleFont;

    if (animated && !CGRectEqualToRect(self.indicatorView.frame, CGRectZero)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorView.frame = CGRectMake(titleButton.frame.origin.x+(titleButton.bounds.size.width-self.innerConfig.indicatorWidth)/2, self.frame.size.height-self.innerConfig.indicatorHeight, self.innerConfig.indicatorWidth, self.innerConfig.indicatorHeight);
        }];
    } else {
        self.indicatorView.frame = CGRectMake(titleButton.frame.origin.x+(titleButton.bounds.size.width-self.innerConfig.indicatorWidth)/2, self.frame.size.height-self.innerConfig.indicatorHeight, self.innerConfig.indicatorWidth, self.innerConfig.indicatorHeight);
    }
    
    if (self.innerConfig.type == JLSwitcherTypeSegment) {
        CGFloat offsetX = titleButton.frame.origin.x - (self.scrollView.bounds.size.width - titleButton.bounds.size.width)/2;
        if (offsetX < 0) {
            offsetX = 0;
        } else if ((offsetX + self.scrollView.bounds.size.width) > self.scrollView.contentSize.width) {
            offsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
        }
        if (self.scrollView.contentSize.width > self.scrollView.bounds.size.width) {
            [self.scrollView setContentOffset:CGPointMake(offsetX, self.scrollView.contentOffset.y)
                                     animated:animated];
        }
    }
    
    if (index == self.selectedIndex) return;
    _selectedIndex = index;
    [self.delegate segementSlideSwitcherView:self didSelectAtIndex:index animated:animated];
}

#pragma mark - Action
- (void)didClickTitleButton:(UIButton *)sender {
    [self selectSwitcherAtIndex:sender.tag animated:YES];
}

#pragma mark - Getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
    }
    return _indicatorView;
}

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [[NSMutableArray alloc] init];
    }
    return _titleButtons;
}

- (NSArray<UIGestureRecognizer *> *)gestureRecognizers {
    return self.scrollView.gestureRecognizers;
}

@end
