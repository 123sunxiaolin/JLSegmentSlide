//
//  JLSegementSlideContentView.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideContentView.h"
#import "UIView+JLConstraint.h"

NSNotificationName const willClearAllReusableViewControllersNotification = @"willClearAllReusableViewControllersNotification";

@interface JLSegementSlideContentView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<JLSegementSlideContentScrollViewDelegate>> *viewControllers;
@property (nonatomic, assign) NSInteger initSelectedIndex;
@property (nonatomic, copy) NSArray <UIGestureRecognizer *> *gestureRecognizersInScrollView;

@end

@implementation JLSegementSlideContentView

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
    self.viewControllers = [[NSMutableDictionary alloc] init];
    self.initSelectedIndex = NSIntegerMin;
    
    [self addSubview:self.scrollView];
    [self.scrollView constraintToSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateScrollViewContentSize];
    [self layoutViewControllers];
    [self recoverInitSelectedIndex];
    [self updateSelectedIndex];
}

- (void)reloadData {
    [self clearAllReusableViewControllers];
    [self updateScrollViewContentSize];
    [self updateSelectedIndex];
}

- (void)scrollToSlideAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self updateSelectedViewControllerAtIndex:index animated:animated];
}

- (id<JLSegementSlideContentScrollViewDelegate>)dequeueReusableViewControllerAtIndex:(NSInteger)index {
    id <JLSegementSlideContentScrollViewDelegate> childViewController = self.viewControllers[@(index).stringValue];
    if (childViewController) {
        return childViewController;
    }
    return nil;
}

#pragma mark - Private
- (void)updateScrollViewContentSize {
    NSInteger count = [self.delegate segementSlideContentScrollViewCount];
    if (!count) return;
    CGSize contentSize = CGSizeMake(count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    if (CGSizeEqualToSize(self.scrollView.contentSize, contentSize)) return;
    self.scrollView.contentSize = contentSize;
}

- (void)layoutViewControllers {
    for (NSInteger index = 0; index < self.viewControllers.allKeys.count; index ++) {
        NSString *key = self.viewControllers.allKeys[index];
        UIViewController *childViewController = (UIViewController *)self.viewControllers[key];
        if (!childViewController.view.superview) return;
        NSInteger targetIndex = [key integerValue];
        CGFloat offsetX = targetIndex * self.scrollView.bounds.size.width;
        childViewController.view.widthConstraint.constant = self.scrollView.bounds.size.width;
        childViewController.view.heightConstraint.constant = self.scrollView.bounds.size.height;
        childViewController.view.leadingConstraint.constant = offsetX;
    }
}

- (void)recoverInitSelectedIndex {
    if (self.initSelectedIndex == NSIntegerMin) return;
    self.initSelectedIndex = NSIntegerMin;
    [self updateSelectedViewControllerAtIndex:self.initSelectedIndex animated:NO];
}

- (void)updateSelectedIndex {
    if (self.selectedIndex == NSIntegerMin) return;
    [self updateSelectedViewControllerAtIndex:self.selectedIndex animated:NO];
}

- (void)clearAllReusableViewControllers {
    [[NSNotificationCenter defaultCenter] postNotificationName:willClearAllReusableViewControllersNotification object:nil];
    for (UIViewController *childViewController in self.viewControllers.allValues) {
        if (childViewController) {
            [childViewController.view removeAllConstraints];
            [childViewController.view removeFromSuperview];
            [childViewController removeFromParentViewController];
        }
    }
    [self.viewControllers removeAllObjects];
}

- (void)updateSelectedViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (CGRectEqualToRect(self.scrollView.frame, CGRectZero)) {
        self.initSelectedIndex = index;
        return;
    }
    
    NSInteger count = [self.delegate segementSlideContentScrollViewCount];
    if (!(self.viewController && index >= 0 && index < count && count != 0)) return;
    
    if (self.selectedIndex != index) {
        id<JLSegementSlideContentScrollViewDelegate> lastChildViewController = [self.delegate segementSlideContentScrollViewAtIndex:self.selectedIndex];
        if (lastChildViewController) {
            // last child viewController viewWillDisappear
            [(UIViewController *)lastChildViewController beginAppearanceTransition:NO animated:animated];
        }
    }
    
    UIViewController *childViewController = (UIViewController *)[self segementSlideContentViewControllerAtIndex:index];
    if (!childViewController) return;
    BOOL isAdded = childViewController.view.superview != nil;
    if (!isAdded) {
        // new child viewController viewDidLoad, viewWillAppear
        [self.viewController addChildViewController:childViewController];
        [self.scrollView addSubview:childViewController.view];
    } else {
        if (index != self.selectedIndex) {
            // current child viewController viewWillAppear
            [childViewController beginAppearanceTransition:YES animated:animated];
        }
    }
    
    CGFloat offsetX = index * self.scrollView.bounds.size.width;
    childViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    childViewController.view.topConstraint = [childViewController.view.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor];
    childViewController.view.widthConstraint = [childViewController.view.widthAnchor constraintEqualToConstant:self.scrollView.bounds.size.width];
    childViewController.view.heightConstraint = [childViewController.view.heightAnchor constraintEqualToConstant:self.scrollView.bounds.size.height];
    childViewController.view.leadingConstraint = [childViewController.view.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:offsetX];
    [self.scrollView setContentOffset:CGPointMake(offsetX, self.scrollView.contentOffset.y) animated:animated];
    
    if (self.selectedIndex != index) {
        id<JLSegementSlideContentScrollViewDelegate> lastChildViewController = [self.delegate segementSlideContentScrollViewAtIndex:self.selectedIndex];
        if (lastChildViewController) {
            // last child viewController viewWillDisappear
            [(UIViewController *)lastChildViewController endAppearanceTransition];
        }
    }
    
    if (isAdded) {
        if (index != self.selectedIndex) {
            // current child viewController viewWillAppear
            [childViewController endAppearanceTransition];
        }
    }
    
    if (index == self.selectedIndex) return;
    _selectedIndex = index;
    [self.delegate segementSlideContentView:self didSelectAtIndex:index animated:animated];
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    // Need to test repeatly.
    NSInteger index = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    if (index >= 0) {
        [self updateSelectedViewControllerAtIndex:index animated:YES];
    }
}

- (id<JLSegementSlideContentScrollViewDelegate>)segementSlideContentViewControllerAtIndex:(NSInteger)index {
    if ([self dequeueReusableViewControllerAtIndex:index]) {
        return [self dequeueReusableViewControllerAtIndex:index];
    }
    id<JLSegementSlideContentScrollViewDelegate> childViewController = [self.delegate segementSlideContentScrollViewAtIndex:index];
    if (childViewController) {
        self.viewControllers[@(index).stringValue] = childViewController;
        return childViewController;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self scrollViewDidEndScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScroll:scrollView];
}

#pragma mark - Getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (NSArray<UIGestureRecognizer *> *)gestureRecognizers {
    return self.scrollView.gestureRecognizers;
}

- (BOOL)isScrollEnabled {
    return self.scrollView.isScrollEnabled;
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    self.scrollView.scrollEnabled = isScrollEnabled;
}

@end
