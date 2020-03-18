//
//  JLSegementSlideViewController.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSegementSlideContentView.h"
#import "JLSegmentSlideSwitcherSharedConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLBouncesType) {
    JLBouncesTypeParent,
    JLBouncesTypeChild
};

@interface JLSegementSlideViewController : UIViewController

@property (nonatomic, strong, readonly) UIScrollView *slideScrollView;
@property (nonatomic, strong, readonly) UIView *slideSwitcherView;
@property (nonatomic, strong, readonly) UIView *slideContentView;

@property (nonatomic, assign, readonly) CGFloat headerStickyHeight;
@property (nonatomic, assign, readonly) CGFloat contentViewHeight;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong, readonly) id <JLSegementSlideContentScrollViewDelegate> currentSegementSlideContentViewController;

@property (nonatomic, assign, readonly) JLBouncesType bouncesType;
@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, assign, readonly) CGFloat switcherHeight;

@property (nonatomic, strong, readonly) JLSegmentSlideSwitcherSharedConfig *switcherConfig;
@property (nonatomic, copy, readonly) NSArray <NSString *> *titlesInSwitcher;

- (JLBadgeType)showBadgeInSwitcherAtIndex:(NSInteger)index;
- (id <JLSegementSlideContentScrollViewDelegate>)segementSlideContentViewControllerAtIndex:(NSInteger)index;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView isParent:(BOOL)isParent;
- (void)didSelectContentViewControllerAtIndex:(NSInteger)index;

/// reload headerView, SwitcherView and ContentView
///
/// you should call `scrollToSlide(at index: Int, animated: Bool)` after call the method.
/// otherwise, none of them will be selected.
/// However, if an item was previously selected, it will be reSelected.
- (void)reloadData;

/// reload headerView
- (void)reloadHeader;

 /// reload SwitcherView
- (void)reloadSwitcher;

/// reload badges in SwitcherView
- (void)reloadBadgeInSwitcher;

 /// reload ContentView
- (void)reloadContent;

/// select one item by index
- (void)scrollToSlideAtIndex:(NSInteger)index animated:(BOOL)animated;

/// reuse the `SegementSlideContentScrollViewDelegate`
- (id<JLSegementSlideContentScrollViewDelegate>)dequeueReusableViewControllerAtIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
