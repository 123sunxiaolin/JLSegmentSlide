//
//  JLSegementSlideContentView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLSegementSlideContentScrollViewDelegate <NSObject>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@end

@class JLSegementSlideContentView;
@protocol JLSegementSlideContentDelegate <NSObject>

@property (nonatomic, assign, readonly) NSInteger segementSlideContentScrollViewCount;

- (id<JLSegementSlideContentScrollViewDelegate>)segementSlideContentScrollViewAtIndex:(NSInteger)index;

- (void)segementSlideContentView:(JLSegementSlideContentView *)segementSlideContentView
                didSelectAtIndex:(NSInteger)index
                        animated:(BOOL)animated;

@end

UIKIT_EXTERN NSNotificationName const willClearAllReusableViewControllersNotification;

@interface JLSegementSlideContentView : UIView

@property (nonatomic, weak) id<JLSegementSlideContentDelegate> delegate;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isScrollEnabled;

/// remove subViews
///
/// you should call `scrollToSlide(at index: Int, animated: Bool)` after call the method.
/// otherwise, none of them will be selected.
/// However, if an item was previously selected, it will be reSelected.
- (void)reloadData;

/// select one item by index
- (void)scrollToSlideAtIndex:(NSInteger)index animated:(BOOL)animated;

 /// reuse the `SegementSlideContentScrollViewDelegate`
- (id<JLSegementSlideContentScrollViewDelegate>)dequeueReusableViewControllerAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
