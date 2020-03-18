//
//  JLSegementSlideScrollView.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSegementSlideScrollView : UIScrollView

- (instancetype)initWithOtherGestureRecognizers:(NSArray <UIGestureRecognizer *> *)otherGestureRecognizers;

@end

NS_ASSUME_NONNULL_END
