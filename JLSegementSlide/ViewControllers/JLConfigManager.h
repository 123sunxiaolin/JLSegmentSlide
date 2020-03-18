//
//  JLConfigManager.h
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLSegmentSlideSwitcherSharedConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface JLConfigManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) JLSegmentSlideSwitcherSharedConfig *switcherConfig;

@end

NS_ASSUME_NONNULL_END
