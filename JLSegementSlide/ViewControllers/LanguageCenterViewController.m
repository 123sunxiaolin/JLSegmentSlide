//
//  LanguageCenterViewController.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "LanguageCenterViewController.h"
#import "JLConfigManager.h"
#import "CALayer+Extension.h"
#import "KKUserDetailHeaderView.h"
#import "JLContentTableViewController.h"

@interface LanguageCenterViewController ()

@property (nonatomic, strong) KKUserDetailHeaderView *centerHeaderView;

@end

@implementation LanguageCenterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self scrollToSlideAtIndex:1 animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    let topLayoutLength: CGFloat
//    if #available(iOS 11.0, *) {
//        topLayoutLength = view.safeAreaInsets.top
//    } else {
//        topLayoutLength = topLayoutGuide.length
//    }
//    slideScrollView.mj_header.ignoredScrollViewContentInsetTop = -topLayoutLength
}

- (JLSegmentSlideSwitcherSharedConfig *)switcherConfig {
    JLSegmentSlideSwitcherSharedConfig *config = [JLConfigManager sharedManager].switcherConfig;
    config.type = JLSwitcherTypeTab;
    return config;
}

- (NSAttributedString *)attributedTextsForEmbed {
    return [[NSAttributedString alloc] initWithString:@"Test" attributes:[UINavigationBar appearance].titleTextAttributes];
}

- (JLBouncesType)bouncesType {
    return JLBouncesTypeParent;
}

- (UIView *)headerView {
    return self.centerHeaderView;
}

- (NSArray<NSString *> *)titlesInSwitcher {
    return @[@"Swift", @"Ruby", @"C++"];
}

- (JLBadgeType)showBadgeInSwitcherAtIndex:(NSInteger)index {
    return JLBadgeTypePoint;
}


- (id<JLSegementSlideContentScrollViewDelegate>)segementSlideContentViewControllerAtIndex:(NSInteger)index {
    [self reloadBadgeInSwitcher];
    return [[JLContentTableViewController alloc] init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isParent:(BOOL)isParent {
    [super scrollViewDidScroll:scrollView isParent:isParent];
    if (!isParent) return;
    [self updateNavigationBarStyle:scrollView];
    [self.centerHeaderView updateBgImageTopContraint:scrollView.contentOffset.y];
}

#pragma mark - Private
- (void)updateNavigationBarStyle:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.headerStickyHeight) {
        [self.slideSwitcherView.layer applySketchShadowWithColor:[UIColor blackColor]
                                                           alpha:0.03
                                                               x:0
                                                               y:2.5
                                                            blur:5
                                                          spread:0];
        [self.slideSwitcherView.layer addAnimation:[self generateFadeAnimation] forKey:@"reloadSwitcherView"];
    } else {
        [self.slideSwitcherView.layer applySketchShadowWithColor:[UIColor clearColor]
                                                           alpha:0
                                                               x:0
                                                               y:0
                                                            blur:0
                                                          spread:0];
        [self.slideSwitcherView.layer addAnimation:[self generateFadeAnimation] forKey:@"reloadSwitcherView"];
    }
}

- (CATransition *)generateFadeAnimation {
    CATransition *fadeTextAnimation = [[CATransition alloc] init];
    fadeTextAnimation.duration = 0.25;
    fadeTextAnimation.type = kCATransitionFade;
    return fadeTextAnimation;
}

#pragma mark - Getters
- (KKUserDetailHeaderView *)centerHeaderView {
    if (!_centerHeaderView) {
        _centerHeaderView = [[[KKUserDetailHeaderView alloc] init] loadFromNib];
    }
    return _centerHeaderView;
}


#pragma mark - Action

#pragma mark - Delegate


@end
