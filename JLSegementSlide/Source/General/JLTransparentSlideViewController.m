//
//  JLTransparentSlideViewController.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/17.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLTransparentSlideViewController.h"
#import "UIView+JLConstraint.h"

@interface JLTransparentSlideViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL hasViewWillAppeared;
@property (nonatomic, assign) BOOL hasEmbed;
@property (nonatomic, assign) BOOL hasDisplay;

@end

@implementation JLTransparentSlideViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self setupTitleLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTitleLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hasViewWillAppeared = YES;
    [self storeDefaultNavigationBarStyle];
    [self reloadNavigationBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self recoverStoredNavigationBarStyle];
}

- (UIView *)headerView {
#if DEBUG
    NSAssert(NO, @"must override this variable");
#endif
    return [UIView new];
}

- (void)reloadData {
    [super reloadData];
    [self reloadNavigationBarStyle];
}

- (void)reloadHeader {
    [super reloadHeader];
    [self reloadNavigationBarStyle];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isParent:(BOOL)isParent {
    if (!isParent) return;
    if (!self.parentScrollView) {
        self.parentScrollView = scrollView;
        return;
    }
    [self updateNavigationBarStyle:scrollView];
}

#pragma mark - Public
- (void)storeDefaultNavigationBarStyle {
    self.storedNavigationController = self.navigationController;
    if (!self.navigationController) return;
    
    BOOL canGo = !self.storedNavigationBarIsTranslucent
    && !self.storedNavigationBarBarStyle
    && !self.storedNavigationBarBarTintColor
    && !self.storedNavigationBarTintColor
    && !self.storedNavigationBarShadowImage
    && !self.storedNavigationBarBackgroundImage;
    if (!canGo) return;
    self.storedNavigationBarIsTranslucent = @(self.navigationController.navigationBar.isTranslucent);
    self.storedNavigationBarBarStyle = @(self.navigationController.navigationBar.barStyle);
    self.storedNavigationBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    self.storedNavigationBarTintColor = self.navigationController.navigationBar.tintColor;
    self.storedNavigationBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    self.storedNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
}

- (void)recoverStoredNavigationBarStyle {
    if (!self.navigationController) return;
    self.navigationController.navigationBar.translucent = self.storedNavigationBarIsTranslucent ? self.storedNavigationBarIsTranslucent.boolValue : NO;
    self.navigationController.navigationBar.barStyle = self.storedNavigationBarBarStyle ? (UIBarStyle)self.storedNavigationBarBarStyle.integerValue : UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = self.storedNavigationBarBarTintColor;
    self.navigationController.navigationBar.tintColor = self.storedNavigationBarTintColor;
    self.navigationController.navigationBar.shadowImage = self.storedNavigationBarShadowImage;
    [self.navigationController.navigationBar setBackgroundImage:self.storedNavigationBarBackgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)reloadNavigationBarStyle {
    if (!self.parentScrollView) return;
    self.hasDisplay = NO;
    self.hasEmbed = NO;
    [self updateNavigationBarStyle:self.parentScrollView];
}

#pragma mark - Private
- (void)setupTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self layoutTitleLabel];
    self.navigationItem.titleView = self.titleLabel;
}

- (void)layoutTitleLabel {
    CGSize titleSize;
    if (self.navigationController) {
        titleSize = CGSizeMake(self.navigationController.navigationBar.bounds.size.width*3/5, self.navigationController.navigationBar.bounds.size.height);
    } else {
        titleSize = CGSizeMake(self.view.bounds.size.width * 3/5, 44);
    }
    if (@available(iOS 11, *)) {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.widthConstraint = [self.titleLabel.widthAnchor constraintEqualToConstant:titleSize.width];
        self.titleLabel.heightConstraint = [self.titleLabel.heightAnchor constraintEqualToConstant:titleSize.height];
    } else {
        self.titleLabel.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    }
}

- (void)updateNavigationBarStyle:(UIScrollView *)scrollView {
    if (!self.hasViewWillAppeared) return;
    if (!self.navigationController) return;
    if (scrollView.contentOffset.y >= self.headerStickyHeight) {
        if (self.hasEmbed) return;
        self.hasEmbed = YES;
        self.hasDisplay = NO;
        self.titleLabel.attributedText = self.attributedTextsForEmbed;
        [self.titleLabel.layer addAnimation:[self generateFadeAnimation] forKey:@"reloadTitleLabel"];
        self.navigationController.navigationBar.translucent = self.isTranslucentsForEmbed;
        self.navigationController.navigationBar.barStyle = self.barStylesForEmbed;
        self.navigationController.navigationBar.tintColor = self.tintColorsForEmbed;
        self.navigationController.navigationBar.barTintColor = self.barTintColorsForEmbed;
        [self.navigationController.navigationBar.layer addAnimation:[self generateFadeAnimation]
                                                             forKey:@"reloadNavigationBar"];
    } else {
        if (self.hasDisplay) return;
        self.hasDisplay = YES;
        self.hasEmbed = NO;
        self.titleLabel.attributedText = self.attributedTextsForDisplay;
        [self.titleLabel.layer addAnimation:[self generateFadeAnimation] forKey:@"reloadTitleLabel"];
        self.navigationController.navigationBar.translucent = self.isTranslucentsForDisplay;
        self.navigationController.navigationBar.barStyle = self.barStylesForDisplay;
        self.navigationController.navigationBar.tintColor = self.tintColorsForDisplay;
        self.navigationController.navigationBar.barTintColor = self.barTintColorsForDisplay;
        [self.navigationController.navigationBar.layer addAnimation:[self generateFadeAnimation]
                                                             forKey:@"reloadNavigationBar"];
    }
}

- (CATransition *)generateFadeAnimation {
    CATransition *fadeTextAnimation = [[CATransition alloc] init];
    fadeTextAnimation.duration = 0.25;
    fadeTextAnimation.type = kCATransitionFade;
    return fadeTextAnimation;
}

#pragma mark - Getters
- (BOOL)isTranslucentsForDisplay {
    return YES;
}

- (BOOL)isTranslucentsForEmbed {
    return NO;
}

- (NSAttributedString *)attributedTextsForDisplay {
    return nil;
}

- (NSAttributedString *)attributedTextsForEmbed {
    return nil;
}

- (UIBarStyle)barStylesForDisplay {
    return UIBarStyleBlack;
}

- (UIBarStyle)barStylesForEmbed {
    return UIBarStyleDefault;
}

- (UIColor *)barTintColorsForDisplay {
    return nil;
}

- (UIColor *)barTintColorsForEmbed {
    return [UIColor whiteColor];
}

- (UIColor *)tintColorsForDisplay {
    return [UIColor whiteColor];
}

- (UIColor *)tintColorsForEmbed {
    return [UIColor blackColor];
}

@end
