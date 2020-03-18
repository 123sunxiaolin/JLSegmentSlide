//
//  JLSegementSlideScrollView.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideScrollView.h"

@interface JLSegementSlideScrollView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray <UIGestureRecognizer *> *otherGestureRecognizers;

@end

@implementation JLSegementSlideScrollView

- (instancetype)init {
    if (self = [super init]) {
        self.otherGestureRecognizers = @[];
    }
    return self;
}

- (instancetype)initWithOtherGestureRecognizers:(NSArray <UIGestureRecognizer *> *)otherGestureRecognizers {
    if (self = [super initWithFrame:CGRectZero]) {
        self.otherGestureRecognizers = otherGestureRecognizers;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.otherGestureRecognizers.count > 0 && [self.otherGestureRecognizers containsObject:otherGestureRecognizer]) {
        return NO;
    }
    return YES;
}

@end
