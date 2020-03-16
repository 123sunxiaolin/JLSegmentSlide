//
//  JLSegementSlideSwitcherView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSegmentSlideConst.h"
#import "JLSegmentSlideSwitcherSharedConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class JLSegementSlideSwitcherView;
@protocol JLSegementSlideSwitcherViewDelegate <NSObject>

@optional

@property (nonatomic, copy, readonly) NSArray *titlesInSegementSlideSwitcherView;

- (void)segementSlideSwitcherView:(JLSegementSlideSwitcherView *)segementSlideSwitcherView
                 didSelectAtIndex:(NSInteger)index
                         animated:(BOOL)animated;

- (JLBadgeType)segementSlideSwitcherView:(JLSegementSlideSwitcherView *)segementSlideSwitcherView
                 showBadgeAtIndex:(NSInteger)index;

@end

@interface JLSegementSlideSwitcherView : UIView

@property (nonatomic, weak) id<JLSegementSlideSwitcherViewDelegate> delegate;

// you must call `reloadData()` to make it work, after the assignment.
@property (nonatomic, strong) JLSegmentSlideSwitcherSharedConfig *config;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/// relayout subViews
///
/// you should call `selectSwitcher(at index: Int, animated: Bool)` after call the method.
/// otherwise, none of them will be selected.
/// However, if an item was previously selected, it will be reSelected.
- (void)reloadData;

/// reload all badges in `SegementSlideSwitcherView`
- (void)reloadBadges;

/// select one item by index
- (void)selectSwitcherAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
