//
//  JLSegmentSlideSwitcherSharedConfig.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegmentSlideSwitcherSharedConfig.h"

@implementation JLSegmentSlideSwitcherSharedConfig

+ (instancetype)sharedConfig {
    static JLSegmentSlideSwitcherSharedConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLSegmentSlideSwitcherSharedConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.type = JLSwitcherTypeSegment;
        self.horizontalMargin = 16;
        self.horizontalSpace = 32;
        self.normalTitleFont = [UIFont systemFontOfSize:15];
        self.selectedTitleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        self.normalTitleColor = [UIColor grayColor];
        self.selectedTitleColor = [UIColor darkGrayColor];
        self.indicatorWidth = 30;
        self.indicatorHeight = 2;
        self.indicatorColor = [UIColor darkGrayColor];
        self.badgeHeightForPointType = 9;
        self.badgeHeightForCountType = 15;
        self.badgeHeightForCustomType = 14;
        self.badgeFontForCountType = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    }
    return self;
}

@end
