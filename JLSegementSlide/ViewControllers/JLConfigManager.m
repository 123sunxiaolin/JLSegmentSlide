//
//  JLConfigManager.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLConfigManager.h"

@implementation JLConfigManager

+ (instancetype)sharedManager {
    static JLConfigManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLConfigManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _switcherConfig = [[JLSegmentSlideSwitcherSharedConfig alloc] init];
    }
    return self;
}


@end
