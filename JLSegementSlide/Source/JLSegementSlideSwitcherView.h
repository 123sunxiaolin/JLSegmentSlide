//
//  JLSegementSlideSwitcherView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSegmentSlideConst.h"

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



@end

NS_ASSUME_NONNULL_END
