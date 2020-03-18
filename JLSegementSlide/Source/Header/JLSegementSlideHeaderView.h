//
//  JLSegementSlideHeaderView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JLSegementSlideContentView;
@interface JLSegementSlideHeaderView : UIView

- (void)configueWithHeaderView:(UIView *)headerView
      segementSlideContentView:(JLSegementSlideContentView *)segementSlideContentView;

@end

NS_ASSUME_NONNULL_END
