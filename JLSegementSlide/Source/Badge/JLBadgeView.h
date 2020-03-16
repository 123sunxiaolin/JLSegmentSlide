//
//  JLBadgeView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSegmentSlideConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBadgeView : UILabel

@end

@interface JLBadge : NSObject

/// Badge's height, Badge's cornerRadius is half of the value
@property (nonatomic, assign) CGFloat height;

/// Badge's center position relative to the parent view's center position displacement
/// A positive x means moving to the right
/// A positive y means moving to the bottom
@property (nonatomic, assign) CGPoint offset;

/// font for the `.count` type
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) JLBadgeType type;

/// `countForBadge` only used for `BadgeTypeCount`, set before `type` Setter
@property (nonatomic, assign) NSInteger countForBadge;

@property (nonatomic, strong) NSAttributedString *attributedStringForCustom;
@property (nonatomic, assign) CGFloat heightForCustom;
@property (nonatomic, assign) CGFloat cornerRadiusForCustom;

- (instancetype)initWithSuperView:(UIView *)superView;

@end

@interface UIView (Badge)

@property (nonatomic, strong, readonly) JLBadge *oneBadge;

@end



NS_ASSUME_NONNULL_END
