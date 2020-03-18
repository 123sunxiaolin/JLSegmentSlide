//
//  JLTransparentSlideViewController.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/17.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideViewController.h"

NS_ASSUME_NONNULL_BEGIN

///
/// Set the navigationBar property in viewWillAppear
///
/// Why do you set properties in viewWillAppear instead of viewDidLoad?
/// - When enter to TransparentSlideViewController(B) from TransparentSlideViewController(A),
/// - viewDidLoad in B will take precedence over viewWillDisappear in A, so that it cannot recover state before displaying B.
///
/// Modifying the titleTextAttributes of navigationBar does not necessarily take effect immediately, so adjust the attributedText of the custom titleView instead.

@interface JLTransparentSlideViewController : JLSegementSlideViewController

@property (nonatomic, weak) UIScrollView *parentScrollView;
@property (nonatomic, weak) UINavigationController *storedNavigationController;
@property (nonatomic, strong) NSNumber *storedNavigationBarIsTranslucent;
@property (nonatomic, strong) NSNumber *storedNavigationBarBarStyle;
@property (nonatomic, strong) UIColor *storedNavigationBarBarTintColor; //UIBarStyle
@property (nonatomic, strong) UIColor *storedNavigationBarTintColor;
@property (nonatomic, strong) UIImage *storedNavigationBarShadowImage;
@property (nonatomic, strong) UIImage *storedNavigationBarBackgroundImage;

@property (nonatomic, assign, readonly) BOOL isTranslucentsForDisplay;
@property (nonatomic, assign, readonly) BOOL isTranslucentsForEmbed;

@property (nonatomic, copy, readonly, nullable) NSAttributedString *attributedTextsForDisplay;
@property (nonatomic, copy, readonly, nullable) NSAttributedString *attributedTextsForEmbed;

@property (nonatomic, assign, readonly) UIBarStyle barStylesForDisplay;
@property (nonatomic, assign, readonly) UIBarStyle barStylesForEmbed;

@property (nonatomic, strong, readonly, nullable) UIColor *barTintColorsForDisplay;
@property (nonatomic, strong, readonly, nullable) UIColor *barTintColorsForEmbed;

@property (nonatomic, strong, readonly) UIColor *tintColorsForDisplay;
@property (nonatomic, strong, readonly) UIColor *tintColorsForEmbed;

- (void)reloadNavigationBarStyle;
- (void)storeDefaultNavigationBarStyle;
- (void)recoverStoredNavigationBarStyle;

@end

NS_ASSUME_NONNULL_END
