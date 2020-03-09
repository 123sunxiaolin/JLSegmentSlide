//
//  UIView+JLConstraint.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JLConstraint)

@property (nonatomic, strong, nullable) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *trailingConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong, nullable) NSLayoutConstraint *heightConstraint;

- (void)constraintToSuperview;
- (void)removeAllConstraints;

@end

NS_ASSUME_NONNULL_END
