//
//  KKUserDetailHeaderView.h
//  KLEKT
//
//  Created by Jacklin on 2020/3/8.
//  Copyright © 2020 Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NibLoadable <NSObject>

@optional
- (instancetype)loadFromNib;

@end

@interface KKUserDetailHeaderView : UIView <NibLoadable>

- (void)updateBgImageTopContraint:(CGFloat)constant;

@end

NS_ASSUME_NONNULL_END
