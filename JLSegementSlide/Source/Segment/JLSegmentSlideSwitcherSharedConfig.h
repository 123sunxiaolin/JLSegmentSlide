//
//  JLSegmentSlideSwitcherSharedConfig.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSegmentSlideConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLSwitcherType);

@interface JLSegmentSlideSwitcherSharedConfig : NSObject

+ (instancetype)sharedConfig;

@property (nonatomic, assign) JLSwitcherType type;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat horizontalSpace;
@property (nonatomic, strong) UIFont *normalTitleFont;
@property (nonatomic, strong) UIFont *selectedTitleFont;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat badgeHeightForPointType;
@property (nonatomic, assign) CGFloat badgeHeightForCountType;
@property (nonatomic, assign) CGFloat badgeHeightForCustomType;
@property (nonatomic, strong) UIFont *badgeFontForCountType;

@end

NS_ASSUME_NONNULL_END
